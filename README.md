# 🎓 MyCampus – Campus Companion App

MyCampus is a Flutter-based mobile application designed to simplify daily campus life for students.  
It brings essential campus utilities like **navigation, planning, scheduling, and login persistence** into one lightweight, easy-to-use app.

This project was developed and upgraded during the hackathon period and is intended as a **functional MVP** for real campus usage.

---

## 🚀 Features

### 🔐 Login & Student Profile
- Simple student login using **Name, College, and UID**
- Login details stored locally using SharedPreferences
- **Auto-login** on next app launch (offline-first)
- Personalized home screen after login

### 🗺️ Campus Map & Navigation
- Interactive campus map with important locations
- Blocks, hostels, and facilities marked with coordinates
- Navigation via Google Maps integration

### 📅 Calendar
- Add and view academic or personal events
- Date-based event tracking
- Clean and minimal UI

### ✅ Planner
- Task management with priorities
- Mark tasks as completed
- Helps manage assignments and deadlines

### 🆘 Help Desk
- Quick access to campus help and support information

---

## 🖼️ Screenshots
> Screenshots are available in the project documentation / PPT submission.

---

## 🛠️ Tech Stack

### Core Technologies
- **Flutter** – Cross-platform app development
- **Dart** – Application logic

### Google Technologies
- **Google Maps SDK** – Campus map & navigation
- **Google Location Services** – User location & routing
- **Material Design (Flutter)** – UI components & theming

### Storage
- **SharedPreferences** – Local storage for login persistence and offline usage

---

## 📦 APK (MVP Build)

A working APK has been generated from the latest codebase and tested on a real Android device.

**APK highlights:**
- Reflects latest login persistence logic
- Offline-first functionality
- Built after project updates (post 1 Dec 2025)

> APK download link is provided in the hackathon submission / PPT.

---

## ⚙️ How to Run Locally

### Prerequisites
- Flutter SDK (stable)
- Android Studio or VS Code
- Android device or emulator

### Steps
```bash
git clone https://github.com/antra-09120/mycampus_v1.git
cd mycampus_v1
flutter pub get
flutter run