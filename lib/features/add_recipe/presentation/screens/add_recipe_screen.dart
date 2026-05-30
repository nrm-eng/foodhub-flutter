import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../l10n/app_localizations.dart';

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();

  // Динамічний список інгредієнтів
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];

  XFile? _pickedImage;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    for (final c in _ingredientControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() => _ingredientControllers.add(TextEditingController()));
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length == 1) return;
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _imageBytes = bytes;
      });
    }
  }

  void _showImageSourceDialog() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Завантажує фото в Storage. Якщо CORS або інша помилка — повертає null,
  // рецепт зберігається без фото.
  Future<String?> _uploadImageToStorage(String userId) async {
    if (_pickedImage == null) return null;
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        'users/$userId/my_recipes/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageRef.putData(
          _imageBytes!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        uploadTask = storageRef.putFile(File(_pickedImage!.path));
      }

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (_) {
      // CORS на веб або інша помилка — зберігаємо рецепт без фото
      return null;
    }
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Збираємо інгредієнти з динамічного списку
      final ingredients = _ingredientControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .join('\n');

      final imageUrl = await _uploadImageToStorage(userId);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('my_recipes')
          .add({
            'name': _nameController.text.trim(),
            'instructions': _instructionsController.text.trim(),
            'ingredients': ingredients,
            'imageUrl': imageUrl ?? '',
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.recipeSaved)));
        _nameController.clear();
        _instructionsController.clear();
        // Dispose before setState — controllers must not be disposed
        // while still attached to TextFields in the widget tree
        for (final c in _ingredientControllers) {
          c.dispose();
        }
        setState(() {
          _ingredientControllers.clear();
          _ingredientControllers.add(TextEditingController());
          _pickedImage = null;
          _imageBytes = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorSaving)));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addRecipe)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Фото
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: kIsWeb
                              ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                              : Image.file(
                                  File(_pickedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.addPhoto,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Назва рецепту
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: l10n.recipeName),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.recipeNameRequired;
                  }
                  if (value.trim().length < 3) {
                    return l10n.recipeNameTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Інгредієнти — динамічний список
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.ingredients,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addIngredient,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.addIngredient),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Валідація списку інгредієнтів через FormField
              FormField<List<String>>(
                validator: (_) {
                  final hasAny = _ingredientControllers.any(
                    (c) => c.text.trim().isNotEmpty,
                  );
                  if (!hasAny) return l10n.atLeastOneIngredient;
                  return null;
                },
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._ingredientControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                onChanged: (_) => field.didChange(null),
                                decoration: InputDecoration(
                                  hintText:
                                      '${l10n.ingredientHint} ${index + 1}',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _removeIngredient(index),
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: _ingredientControllers.length > 1
                                    ? colorScheme.error
                                    : colorScheme.onSurface.withValues(
                                        alpha: 0.3,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 12),
                        child: Text(
                          field.errorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.error),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Інструкція
              TextFormField(
                controller: _instructionsController,
                maxLines: 5,
                decoration: InputDecoration(hintText: l10n.cookingInstructions),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.instructionsRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Кнопка збереження
              ElevatedButton(
                onPressed: _isLoading ? null : _saveRecipe,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.saveRecipe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
