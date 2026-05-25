import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

Future<void> main() async {
  // Потрібно викликати перед будь-якими async операціями
  WidgetsFlutterBinding.ensureInitialized();

  // Фіксуємо орієнтацію — тільки портретна (вертикальна)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: FoodHubApp(),
    ),
  );
}