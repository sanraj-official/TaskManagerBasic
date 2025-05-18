# 📋 Task Manager App

A simple Flutter application that demonstrates local data persistence using **SQLite** and **SharedPreferences** .

---

## ✅ Features

- 👤 **User Setup** with `SharedPreferences`
  - Prompt for user name on first launch
  - Welcome message on subsequent launches

- 🗂️ **Task Management** with `SQLite`
  - Add, edit, delete tasks
  - Mark tasks as complete/incomplete
  - View task list with creation date
  - Optional: Filter tasks by completion status

---

## 📦 Packages Used

```yaml
sqflite: ^2.3.2             # Local SQLite database for task storage  
shared_preferences: ^2.2.2  # Storing user data like username  
marquee: ^2.2.3             # Scrolling long text titles in the UI  
intl: ^0.18.1               # Date formatting (e.g., task creation time)
```

---

## 🛠️ Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/sanraj-official/TaskManagerBasic.git
cd task_manager_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

Make sure you have a simulator or a connected device running.

---

## 📲 APK Download

[Download APK from Google Drive](https://drive.google.com/file/d/1RRNpROEHNIsWkGvHDsoiTZ61UCZJenUA/view?usp=sharing)

---

## 📁 Project Structure

```
lib/
├── main.dart
├── models/
│   └── task_model.dart
├── services/
│   ├── database_service.dart
│   └── shared_pref_service.dart
├── screens/
│   ├── home_screen.dart
│   └── add_edit_task_screen.dart
└── widgets/
    └── task_tile.dart
```

---

## 💡 Environment Info

```bash
Flutter 3.13.6 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ead455963c (1 year, 8 months ago) • 2023-09-26 18:28:17 -0700
Engine • revision a794cf2681
Tools • Dart 3.1.3 • DevTools 2.25.0
```

---

## 📌 Notes

- State management is handled with `setState` to keep it simple and easy to understand.
- Error handling and validation included for task creation and user setup.
- Clean UI with modular code structure for maintainability.

---

## ✉️ Contact

For any queries, reach out to:  
**Sanraj**  
2sanraj@gmail.com