# Mr. House — E-Learning Platform

A Flutter-based e-learning app with Firebase backend, featuring role-based access for students and professors.

## Features

- Email/password authentication with signup, login, and password reset
- Dual-role system: Student and Professor with separate UIs
- Course catalog with category filtering (Math, Science, Arabic, English, Physics)
- Course enrollment and favorites
- Lecture management with YouTube video playback (uses unlisted YouTube links as content source, not for public viewing)
- Professor tools: create/edit/delete courses and lectures via long-press dialogs
- Student star rating system for courses
- Profile management with editable fields and password change
- Dark mode toggle
- Contact and social media links in settings

## Project Demo

Watch the full demo video here:

```text
https://drive.google.com/file/d/1kD8KmU5hdo1VXxRdPVvjlNOE3x3HxrqZ
```

## Tech Stack & Architecture

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Firebase Auth, Firestore |
| State Management | Cubit (Bloc) |
| Architecture | Layer-First MVVM |

**Architecture layers:** `Core/` → `Models/` → `Repositories/` → `ViewModels/` → `Views/`

## Setup & Installation

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app (ensure a device/emulator is connected)
flutter run
```
