# Quark 🔬

**AI-powered academic assistant, study tools, and exam preparation for Android & iOS.**

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Demo](#demo)
- [Technology Stack](#technology-stack)
- [Cloud Services](#cloud-services)
- [System Architecture](#system-architecture)
- [Project Structure](#project-structure)
- [Try It Yourself](#try-it-yourself)
- [Future Scope](#future-scope)
- [Developer](#developer)

---

## Overview

Quark is a comprehensive Flutter-based mobile application that serves as an AI-powered study companion for engineering students. The app integrates conversational AI, automated exam paper generation, document summarization, and code debugging into a single, beautifully designed interface.

Built with modern technologies including Flutter 3.9, Firebase, and Groq AI, Quark demonstrates proficiency in cross-platform mobile development, cloud integration, AI/ML API consumption, and user-centric design following Material Design 3 guidelines.

**Highlights**:
- 18 fully functional screens
- Real-time AI chat with 5 specialized modes
- University-pattern exam paper generator (SPPU 2019)
- Document processing for PDF, DOC, and TXT files
- Firebase authentication with cloud sync
- Offline-first architecture with SQLite persistence
- Light/Dark theme support

---

## Key Features

### 🤖 AI Chat Assistant
Conversational interface powered by Groq's GPT-OSS-120B model with five specialized modes:
- **General**: Open-ended academic discussions
- **Summarize**: Condense lengthy content
- **Translate**: Language translation
- **Grammar**: Writing assistance
- **Explain**: Concept breakdown

### 📝 Exam Paper Generator
Automated question paper generation following SPPU 2019 pattern:
- Course selection: Computer Engineering, IT, AI & Data Science
- Year-wise subjects (2nd, 3rd, 4th Year)
- Upload syllabus PDFs for context-aware generation
- Configurable marks, duration, and difficulty

### 📄 Document Summarizer
AI-powered document analysis:
- Supports PDF, DOC, DOCX, TXT files
- Key point extraction
- Instant summarization using Mixtral-8x7B

### 💻 Code Assistant
Programming help and debugging:
- Multi-language support
- Syntax error detection
- Optimization suggestions
- Step-by-step explanations

### 📊 Study Analytics
Progress tracking dashboard:
- Daily prompt usage (20/day) with circular progress
- Study streak monitoring
- Recent chats quick access

### 🎨 Modern UI/UX
- Material Design 3
- System/Light/Dark themes
- Google Fonts integration
- Smooth animations
- Bottom navigation with IndexedStack

---

## Demo

### Screenshots

| Dashboard | AI Chat | Tools | Exam Generator |
|-----------|---------|-------|----------------|
| Home with stats | Conversation UI | 6-tool grid | Paper config |

*Screenshots to be added*

### Download APK

📥 **[Download Quark APK v0.1.0](https://github.com/yourusername/quark/releases/download/v0.1.0/quark-v0.1.0.apk)**

---

## Technology Stack

### Core
| Technology | Version | Usage |
|------------|---------|-------|
| Flutter | 3.9+ | Cross-platform framework |
| Dart | 3.9.2+ | Programming language |

### Firebase Suite
| Service | Usage |
|---------|-------|
| Firebase Auth | Email/password authentication |
| Firebase Realtime Database | User profile sync |
| Firebase Storage | Profile picture uploads |

### Local Storage
| Technology | Usage |
|------------|-------|
| SQLite (sqflite) | Chat history persistence |
| SharedPreferences | Settings, streak data |

### AI Integration
| API | Model | Usage |
|-----|-------|-------|
| Groq | GPT-OSS-120B | Chat, paper generation |
| Groq | Mixtral-8x7B | Document summarization |

### UI Libraries
| Package | Usage |
|---------|-------|
| google_fonts | Typography |
| percent_indicator | Progress widgets |
| syncfusion_flutter_gauges | Analytics |
| file_picker | Document upload |
| image_picker | Camera/gallery |
| dotted_border | UI decorations |

---

## Cloud Services

| Service | Purpose | Integration |
|---------|---------|-------------|
| **Firebase Authentication** | Secure user identity | `firebase_auth` package |
| **Firebase Realtime Database** | Cloud data sync | `firebase_database` package |
| **Firebase Storage** | Media storage | `firebase_storage` package |
| **Groq API** | AI inference | REST API via `http` package |

---

## System Architecture

Quark follows the **Model-View-Controller (MVC)** pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                        QUARK APP                             │
├─────────────────────────────────────────────────────────────┤
│  VIEW LAYER (18 Screens)                                     │
│  Dashboard │ Chat │ Tools │ Profile │ Settings │ ...        │
├─────────────────────────────────────────────────────────────┤
│  CONTROLLER LAYER (6 Controllers)                            │
│  AuthController │ DatabaseController │ GroqFunctions         │
├─────────────────────────────────────────────────────────────┤
│  MODEL LAYER                                                 │
│  UserModel │ ChatModel                                       │
├─────────────────────────────────────────────────────────────┤
│  PERSISTENCE                    │  CLOUD SERVICES            │
│  SQLite │ SharedPreferences     │  Firebase │ Groq API       │
└─────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── main.dart                    # Entry point, theme setup
├── Controller/                  # Business logic (6 files)
│   ├── auth_controller.dart     # Firebase Auth operations
│   ├── database_controller.dart # SQLite CRUD
│   ├── groq_functions.dart      # AI API integration
│   └── ...
├── Model/                       # Data models (2 files)
│   ├── user_model.dart
│   └── chat_model.dart
├── View/                        # UI screens (18 files)
│   ├── dashboard.dart           # Main home screen
│   ├── chat_screen.dart         # AI conversation
│   ├── exam_customizer.dart     # Paper generator
│   ├── tools_screen.dart        # Tools grid
│   └── ...
├── Widgets/                     # Reusable components (4 files)
└── Settings/                    # Theme config (2 files)
```

**Stats**: 32 Dart files | 18 screens | ~200 KB source | 14 dependencies

---

## Try It Yourself

### Option 1: Download APK
Download and install the APK directly on your Android device.

### Option 2: Run from Source

```bash
git clone https://github.com/yourusername/quark.git
cd quark
flutter pub get
flutter run
```

> Firebase and Groq API are pre-configured. The app is ready to run.

---

## Future Scope

- **Voice Assistant** – Hands-free voice commands
- **Offline AI** – On-device LLM for complete offline mode
- **Collaborative Study** – Shared rooms and group features
- **Smart Notifications** – AI-powered study reminders
- **Multi-language** – Regional language support
- **Handwriting Recognition** – Scan handwritten notes

---

## Developer

| | |
|---|---|
| **Name** | Your Name |
| **Email** | your.email@example.com |
| **GitHub** | [@yourusername](https://github.com/yourusername) |
| **LinkedIn** | [Your Profile](https://linkedin.com/in/yourprofile) |

---

<p align="center">
  <strong>Built with Flutter 💙 | Powered by Groq AI 🚀</strong>
</p>
