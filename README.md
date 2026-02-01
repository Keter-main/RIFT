# Quark 🔬

**AI-powered academic assistant, study tools, and exam preparation for Android & iOS.**

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Screenshots](#screenshots)
- [Technology Stack](#technology-stack)
- [Cloud Services](#cloud-services)
- [System Architecture](#system-architecture)
- [Project Structure](#project-structure)
- [Installation & Setup](#installation--setup)
- [Future Scope](#future-scope)
- [Developer](#developer)

---

## Overview

Quark is a comprehensive Flutter-based mobile application that serves as an AI-powered study companion for engineering students. The app integrates conversational AI, automated exam paper generation, document summarization, and code debugging into a single, beautifully designed interface.

Built with modern technologies including Flutter 3.9, Firebase, and Groq AI, Quark demonstrates proficiency in cross-platform mobile development, cloud integration, AI/ML API consumption, and user-centric design following Material Design 3 guidelines.

### Highlights

| Metric | Value |
|--------|-------|
| Total Screens | 18 |
| Controllers | 6 |
| Data Models | 2 |
| Reusable Widgets | 4 |
| Source Code Size | ~200 KB |
| Dependencies | 14 |

---

## Key Features

### 🤖 AI Chat Assistant
Conversational interface powered by Groq's GPT-OSS-120B model with five specialized modes:
- **General**: Open-ended academic discussions
- **Summarize**: Condense lengthy content instantly
- **Translate**: Multi-language translation
- **Grammar**: Writing and grammar assistance
- **Explain**: Complex concept breakdown

### 📝 Exam Paper Generator
Automated question paper generation following SPPU 2019 pattern:
- Courses: Computer Engineering, IT, AI & Data Science
- Year-wise subject selection (2nd, 3rd, 4th Year)
- Upload syllabus PDFs for context-aware generation
- Configurable marks, duration, and paper title

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
- Responsive layouts

---

## Screenshots

> **How to add screenshots:**
> 1. Create a folder called `screenshots` in your project root
> 2. Take screenshots from your device/emulator
> 3. Save them as `dashboard.png`, `chat.png`, `tools.png`, `exam.png`
> 4. Replace the placeholder paths below with your actual image paths

| Dashboard | AI Chat |
|-----------|---------|
| ![Dashboard](screenshots/dashboard.png) | ![Chat](screenshots/chat.png) |

| Tools | Exam Generator |
|-------|----------------|
| ![Tools](screenshots/tools.png) | ![Exam](screenshots/exam.png) |

---

## Technology Stack

### Core Framework

| Technology | Version | Description |
|------------|---------|-------------|
| Flutter | 3.9+ | Google's cross-platform UI toolkit |
| Dart | 3.9.2+ | Programming language for Flutter |

### Firebase Suite

| Service | Package | Description |
|---------|---------|-------------|
| Authentication | `firebase_auth` ^6.1.0 | Email/password user authentication |
| Realtime Database | `firebase_database` ^12.0.2 | Cloud data synchronization |
| Storage | `firebase_storage` ^13.0.2 | Profile picture storage |
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

### UI/UX Libraries

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

## Cloud Services

| Service | Purpose | Features Used |
|---------|---------|---------------|
| **Firebase Auth** | User identity | Sign-up, login, logout, password reset |
| **Firebase Database** | Cloud sync | User profiles, usage statistics |
| **Firebase Storage** | Media storage | Profile picture uploads |
| **Groq API** | AI inference | Chat completions, summarization |

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
│   │   └── ... (12 more screens)
│   │
│   ├── Widgets/                     # Components (4 files)
│   │   ├── custom_drawer.dart
│   │   ├── chat_popup.dart
│   │   └── ...
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

Before running this project, ensure you have the following installed:

| Requirement | Version | Download Link |
|-------------|---------|---------------|
| Flutter SDK | 3.9+ | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Android Studio | Latest | [developer.android.com/studio](https://developer.android.com/studio) |
| Git | Latest | [git-scm.com/downloads](https://git-scm.com/downloads) |

### Step 1: Install Flutter

**Windows:**
```bash
# Download Flutter SDK from flutter.dev
# Extract to C:\flutter
# Add C:\flutter\bin to PATH environment variable

# Verify installation
flutter doctor
```

**macOS:**
```bash
# Using Homebrew
brew install flutter

# Or download manually from flutter.dev
# Extract and add to PATH in ~/.zshrc:
export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"

# Verify installation
flutter doctor
```

**Linux:**
```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/flutter/bin"

# Apply changes
source ~/.bashrc

# Verify installation
flutter doctor
```

### Step 2: Verify Installation

Run `flutter doctor` and ensure all checks pass:

```bash
flutter doctor
```

Expected output:
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device
```

### Step 3: Clone and Run

```bash
# Clone the repository
git clone https://github.com/Keter-main/quark.git
cd quark

# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### Step 4: Download APK (Alternative)

If you prefer to directly install without building:

📥 **[Download Quark APK v0.1.0](https://github.com/Keter-main/quark/releases/download/v0.1.0/quark-v0.1.0.apk)**

1. Download the APK file
2. Enable "Install from Unknown Sources" in device settings
3. Install and launch the app
4. Create your account and start exploring!

---

## Future Scope

| Feature | Description |
|---------|-------------|
| **Voice Assistant** | Hands-free voice commands for accessibility |
| **Offline AI** | On-device LLM for complete offline functionality |
| **Collaborative Study** | Shared study rooms and group features |
| **Smart Notifications** | AI-powered study reminders based on patterns |
| **Multi-language** | Regional language support for wider reach |
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
