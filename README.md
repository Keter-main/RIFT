# Quark 🔬

**AI-powered academic assistant, study tools, and exam preparation for Android & iOS.**

---

## Table of Contents

- [Overview](#overview)
- [Screenshots](#screenshots)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [System Architecture](#system-architecture)
- [Project Structure](#project-structure)
- [Installation & Setup](#installation--setup)
- [Future Scope](#future-scope)
- [Developer](#developer)

---

## Overview

Quark is a comprehensive Flutter-based mobile application that serves as an AI-powered study companion for engineering students. The app integrates conversational AI, automated exam paper generation, document summarization, and code debugging into a single, beautifully designed interface.

Built with Flutter 3.9, Firebase, and Groq AI, Quark demonstrates proficiency in cross-platform mobile development, cloud integration, AI/ML API consumption, and Material Design 3.

### Project Highlights

| Metric | Value |
|--------|-------|
| Total Screens | 18 |
| Controllers | 6 |
| Data Models | 2 |
| Reusable Widgets | 4 |
| Source Code | ~200 KB |
| Dependencies | 14 |

---

## Screenshots

| Dashboard | Tools | Saved |
|-----------|-------|-------|
| ![Dashboard](screenshots/dashboard.jpeg) | ![Tools](screenshots/tools.jpeg) | ![Saved](screenshots/saved.jpeg) |

| Chat | Account | Exam Generator |
|------|---------|----------------|
| ![Chat](screenshots/chat.jpeg) | ![Account](screenshots/account.jpeg) | ![Exam Generator](screenshots/exam_generator.jpeg) |

---

## Key Features

### 🤖 AI Chat Assistant

Conversational interface powered by Groq's GPT-OSS-120B model with five specialized modes:

| Mode | Description |
|------|-------------|
| General | Open-ended academic discussions |
| Summarize | Condense lengthy content instantly |
| Translate | Multi-language translation |
| Grammar | Writing and grammar assistance |
| Explain | Complex concept breakdown |

### 📝 Exam Paper Generator

Automated question paper generation following SPPU 2019 pattern:

- **Courses**: Computer Engineering, IT, AI & Data Science
- **Years**: 2nd, 3rd, 4th Year subject selection
- **Upload**: Syllabus PDFs for context-aware generation
- **Configure**: Custom marks, duration, and paper title

### 📄 Document Summarizer

AI-powered document analysis using Mixtral-8x7B:

- Supports PDF, DOC, DOCX, TXT files
- Key point extraction
- Instant summarization

### 💻 Code Assistant

Programming help and debugging:

- Multi-language support
- Syntax error detection and fixes
- Code optimization suggestions
- Step-by-step logic explanations

### 📊 Study Analytics Dashboard

- Daily prompt usage tracking (20/day limit)
- Study streak monitoring with visual indicators
- Recent chats quick access
- Progress visualization with circular gauges

### 🎨 Modern UI/UX

- Material Design 3 implementation
- System/Light/Dark theme support
- Google Fonts integration
- Smooth animations and transitions
- Responsive layouts for all screen sizes

---

## Technology Stack

### Core Framework

| Technology | Version | Description |
|------------|---------|-------------|
| Flutter | 3.9+ | Cross-platform UI toolkit |
| Dart | 3.9.2+ | Programming language |

### Firebase Services

| Service | Package | Description |
|---------|---------|-------------|
| Authentication | `firebase_auth` ^6.1.0 | Email/password login |
| Realtime Database | `firebase_database` ^12.0.2 | Cloud data sync |
| Storage | `firebase_storage` ^13.0.2 | Profile pictures |
| Core | `firebase_core` ^4.1.1 | Firebase initialization |

### Local Storage

| Technology | Package | Description |
|------------|---------|-------------|
| SQLite | `sqflite` ^2.4.2 | Chat history persistence |
| Preferences | `shared_preferences` ^2.5.3 | Settings and streak data |

### AI Integration

| API | Model | Description |
|-----|-------|-------------|
| Groq | GPT-OSS-120B | Chat completions, paper generation |
| Groq | Mixtral-8x7B | Document summarization |

### UI Libraries

| Package | Version | Description |
|---------|---------|-------------|
| `google_fonts` | ^6.3.2 | Custom typography |
| `percent_indicator` | ^4.2.5 | Circular progress widgets |
| `syncfusion_flutter_gauges` | ^31.1.22 | Analytics gauges |
| `dotted_border` | ^3.1.0 | Decorative borders |
| `file_picker` | ^10.3.3 | Document upload |
| `image_picker` | ^1.2.0 | Camera/gallery selection |
| `intl` | ^0.20.2 | Date/time formatting |

---

## System Architecture

Quark follows the **Model-View-Controller (MVC)** architectural pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                        QUARK APP                             │
├─────────────────────────────────────────────────────────────┤
│  VIEW LAYER (18 Screens)                                     │
│  Dashboard │ Chat │ Tools │ Profile │ Settings │ Exam       │
├─────────────────────────────────────────────────────────────┤
│  CONTROLLER LAYER (6 Controllers)                            │
│  AuthController │ DatabaseController │ GroqFunctions         │
├─────────────────────────────────────────────────────────────┤
│  MODEL LAYER (2 Models)                                      │
│  UserModel │ ChatModel                                       │
├─────────────────────────────────────────────────────────────┤
│  PERSISTENCE                    │  CLOUD SERVICES            │
│  SQLite │ SharedPreferences     │  Firebase │ Groq API       │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility |
|-------|----------------|
| **View** | UI screens, user interaction, navigation |
| **Controller** | Business logic, API calls, database operations |
| **Model** | Data structures, serialization |
| **Persistence** | Local storage for offline access |
| **Cloud** | Authentication, sync, AI inference |

---

## Project Structure

```
quark/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase config
│   │
│   ├── Controller/                  # Business Logic (6 files)
│   │   ├── auth_controller.dart     # Authentication
│   │   ├── database_controller.dart # SQLite operations
│   │   ├── groq_functions.dart      # AI integration
│   │   ├── DB_Controller.dart       # Preferences
│   │   └── Firebase_Controller.dart # Cloud sync
│   │
│   ├── Model/                       # Data Models (2 files)
│   │   ├── user_model.dart
│   │   └── chat_model.dart
│   │
│   ├── View/                        # UI Screens (18 files)
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── dashboard.dart
│   │   ├── chat_screen.dart
│   │   ├── exam_customizer.dart
│   │   ├── tools_screen.dart
│   │   ├── saved_chat_screen.dart
│   │   ├── account_section_screen.dart
│   │   ├── profile_page.dart
│   │   ├── settings_page.dart
│   │   ├── document_summarizer_screen.dart
│   │   ├── code_assisstant_screen.dart
│   │   └── ... (6 more screens)
│   │
│   ├── Widgets/                     # Components (4 files)
│   │   ├── custom_drawer.dart
│   │   ├── chat_popup.dart
│   │   ├── chat_history_drawer.dart
│   │   └── quark_logo.dart
│   │
│   └── Settings/                    # Config (2 files)
│       ├── theme_data.dart
│       └── font_data.dart
│
├── assets/                          # Images, icons
├── android/                         # Android config
├── ios/                             # iOS config
└── pubspec.yaml                     # Dependencies
```

---

## Installation & Setup

### Prerequisites

| Requirement | Download |
|-------------|----------|
| Flutter SDK 3.9+ | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Android Studio | [developer.android.com/studio](https://developer.android.com/studio) |
| Git | [git-scm.com/downloads](https://git-scm.com/downloads) |

### Install Flutter

**Windows:**
```bash
# Download Flutter SDK from flutter.dev
# Extract to C:\flutter
# Add C:\flutter\bin to PATH
flutter doctor
```

**macOS:**
```bash
brew install flutter
# Or download manually and add to PATH
flutter doctor
```

**Linux:**
```bash
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor
```

### Clone & Run

```bash
# Clone repository
git clone https://github.com/Keter-main/quark.git
cd quark

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

### Download APK

📥 **[Download Quark APK v0.1.0](https://github.com/Keter-main/quark/releases/download/v0.1.0/quark-v0.1.0.apk)**

1. Download the APK file
2. Enable "Install from Unknown Sources"
3. Install and create your account

---

## Future Scope

| Feature | Description |
|---------|-------------|
| **Voice Assistant** | Hands-free voice commands for accessibility |
| **Offline AI** | On-device LLM for complete offline mode |
| **Collaborative Study** | Shared study rooms and group features |
| **Smart Notifications** | AI-powered study reminders |
| **Multi-language** | Regional language support |
| **Handwriting OCR** | Scan and digitize handwritten notes |

---

## Developer

| | |
|---|---|
| **Name** | Aryan Patil |
| **Email** | aryanpatil5712@gmail.com |
| **GitHub** | [@Keter-main](https://github.com/Keter-main) |

---

## License

This project is open source under the MIT License.

---

<p align="center">
  <strong>Built with Flutter 💙 | Powered by Groq AI 🚀</strong>
</p>
