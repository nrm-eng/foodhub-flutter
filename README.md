# FoodHub

Мобільний додаток для перегляду та пошуку рецептів зі всього світу, з можливістю вести власну кулінарну колекцію.

Розроблений на Flutter 3.24+ · Dart 3.5+ · Material Design 3 · Riverpod · GoRouter · Firebase Auth + Firestore + Storage · TheMealDB API.

---

## Про додаток

FoodHub — це рецептний додаток з підтримкою власних рецептів, вибраного та синхронізацією через Firebase. Користувач переглядає страви з TheMealDB API, зберігає улюблені, додає власні рецепти з фото та налаштовує тему і мову інтерфейсу.

---

## Основний функціонал

- Перегляд рецептів за категоріями з реальним API (TheMealDB)
- Пошук рецептів, рецепт дня, деталі з інгредієнтами та інструкцією
- Вибране з real-time оновленням через Firestore StreamBuilder
- Власні рецепти: створення, перегляд, редагування, видалення (CRUD)
- Завантаження фото з камери або галереї у Firebase Storage
- Firebase Auth: реєстрація, вхід, вихід, скидання пароля
- Захищені маршрути через GoRouter redirect
- Перемикання теми (світла / темна / системна)
- Тема і мова зберігаються після перезапуску через SharedPreferences
- Локалізація: українська, англійська, польська

---

## Технічний стек

Проект побудований на Flutter 3.24+ з Material Design 3. Стан додатку керується через Riverpod (StateNotifier, FutureProvider, StreamProvider). Навігація реалізована через GoRouter з захищеними маршрутами. Backend — Firebase Auth, Firestore та Storage. Дані рецептів завантажуються з TheMealDB REST API через Repository pattern. Налаштування зберігаються локально через SharedPreferences. Інтерфейс локалізований через Flutter Intl (ARB файли). Тестування — flutter_test та mocktail.

---

## Архітектура

Clean Architecture + Feature First. Кожна фіча — окремий модуль `data / domain / presentation`. Domain-шар не залежить від конкретних реалізацій.

```
lib/
├── app/                 # GoRouter, AppShell, MaterialApp
├── core/                # Теми, константи, кешування
├── l10n/                # ARB файли + AppLocalizations
└── features/
    ├── auth/            # Firebase Auth
    ├── home/            # Головний екран, API
    ├── details/         # Деталі рецепту
    ├── favorites/       # Вибране та мої рецепти
    ├── add_recipe/      # Додавання рецепту
    ├── search/          # Пошук
    └── profile/         # Профіль, тема, мова
test/
├── unit/                # Unit тести моделей та репозиторію
└── widget/              # Widget тести екранів
```

---

## Запуск

```bash
git clone https://github.com/nrm-eng/foodhub-flutter.git
cd foodhub-flutter
flutter pub get
flutter run
```

```bash
flutter run -d chrome --web-port 8080   # веб
flutter build apk --debug               # Android APK
```

> `lib/firebase_options.dart` не комітується. Потрібно підключити власний Firebase проект через `flutterfire configure` та увімкнути Email/Password Auth і Firestore.

---

## Тести

```bash
flutter test       # 24/24 passed
flutter analyze    # 0 issues
```

16 unit тестів + 8 widget тестів.

---

## Скріншоти

