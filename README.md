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

<img width="576" height="1280" alt="photo_2026-05-30_10-03-22" src="https://github.com/user-attachments/assets/4293f382-b0ce-49ff-8321-70601c87b1cf" />


<img width="200" alt="photo_2026-05-30_10-03-05" src="https://github.com/user-attachments/assets/2755904a-311f-4494-96ec-0bc0ac2f2386" /> <img width="200" alt="photo_2026-05-30_10-03-24 (2)" src="https://github.com/user-attachments/assets/abffb6c9-864c-40d9-9b3f-b2a1e8d24d1b" /> <img width="200" alt="photo_2026-05-30_10-03-07" src="https://github.com/user-attachments/assets/a3e32feb-74a4-489b-9ab5-bcb08f5f6b6b" /> <img width="200" alt="photo_2026-05-30_10-03-09" src="https://github.com/user-attachments/assets/699971cb-d79a-4f84-a625-4e81fa978db2" /> <img width="200" alt="photo_2026-05-30_10-03-29" src="https://github.com/user-attachments/assets/4a432d7e-55b8-491d-935e-2330ade38e54" /> <img width="200" alt="photo_2026-05-30_10-03-16" src="https://github.com/user-attachments/assets/88e732b4-9062-4f45-b7e0-5a6c69d18a01" />


<img width="200" alt="photo_2026-05-30_10-03-17" src="https://github.com/user-attachments/assets/d2a95a20-bfe8-4a92-b12f-e9d130d7b819" /> <img width="200" alt="photo_2026-05-30_10-03-28" src="https://github.com/user-attachments/assets/10782d60-a045-4e57-9f99-255b4a5510cc" /> <img width="200" alt="photo_2026-05-30_10-03-19" src="https://github.com/user-attachments/assets/e1b03626-3c72-4128-bf11-917806a929cb" /> <img width="200" alt="photo_2026-05-30_10-03-19 (2)" src="https://github.com/user-attachments/assets/dec39a19-9d67-47e2-8fce-7243b18ea73e" />


<img width="200" alt="photo_2026-05-30_10-03-20" src="https://github.com/user-attachments/assets/6b9ac068-cf17-4086-a710-386a5a1c37f0" /> <img width="200" alt="photo_2026-05-30_10-03-21" src="https://github.com/user-attachments/assets/de8491fc-bd94-4a40-a3df-e107e843deb8" /> <img width="200" alt="photo_2026-05-30_10-03-30" src="https://github.com/user-attachments/assets/9654edb6-41dd-4a15-8fc4-76ee5d55f5af" />
