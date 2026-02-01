# Quark 🔬

**AI-powered academic assistant, study tools, and exam preparation for Android & iOS.**

---

## Table of Contents

- [Overview](#overview)
- [Problem](#problem)
- [Solution](#solution)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Cloud Services Used](#cloud-services-used)
- [Screenshots](#screenshots)
- [Installation & Setup](#installation--setup)
- [Contributing](#contributing)
- [Contact](#contact)

---

## Overview

Quark is an intelligent Flutter-based mobile application designed to enhance academic productivity for engineering students. The application combines AI-powered conversational assistance, automated exam paper generation, document summarization, and code debugging within a unified interface.

The app leverages Groq's high-performance AI models (GPT-OSS-120B and Mixtral-8x7B) to deliver fast, contextual responses. Core features include chat history persistence using SQLite, Firebase-based user authentication and data sync, and full offline support for saved conversations.

Quark follows the Model-View-Controller (MVC) architecture pattern with 18 distinct screens, 6 controllers, 2 data models, and 4 reusable widget components. The codebase comprises approximately 200KB of Dart source code organized into modular, maintainable packages.

Quark is primarily targeted at engineering students preparing for university exams (specifically SPPU 2019 pattern), with extended usefulness for developers, researchers, and lifelong learners.

---

## Problem

Engineering students face persistent challenges in managing their academic workload effectively. Preparing for exams often requires creating practice papers manually, which is time-consuming and inconsistent with actual university patterns.

Study materials such as research papers, lecture notes, and documentation are often lengthy and require significant time to extract key information. Additionally, debugging code during assignments and projects demands technical expertise that is not always readily available.

Students also struggle with maintaining consistent study habits due to lack of progress tracking and fragmented tooling across multiple applications. Key pain points include:

- Manual exam paper creation without pattern consistency
- Time-consuming document reading and note extraction
- Limited access to code debugging assistance
- No unified platform for study management
- Lack of study streak and progress tracking
- Scattered tools requiring multiple applications

---

## Solution

Quark provides a unified Android and iOS solution that integrates AI-powered study assistance, exam preparation, and productivity tracking within a single application. The app uses cloud-based AI inference through Groq API for intelligent responses while maintaining local data persistence for offline functionality.

The AI chat system supports multiple specialized modes including summarization, translation, grammar correction, and concept explanation. Each mode configures the AI with specific system prompts optimized for the task. Exam paper generation follows the SPPU 2019 pattern with support for uploading syllabi and source documents to generate contextually relevant questions.

User authentication is handled through Firebase Authentication with email/password credentials, enabling cross-device synchronization of profiles, preferences, and usage statistics. Chat history is stored locally using SQLite with session management, ensuring conversations remain accessible without internet connectivity.

The application implements study streak tracking using SharedPreferences, monitoring daily activity and maintaining motivation through visual progress indicators. All UI components follow Material Design 3 guidelines with full support for system-based, light, and dark themes.

---

## Key Features

### AI Chat Assistant
- Natural language conversation interface powered by Groq AI (GPT-OSS-120B model)
- Five specialized chat modes: General, Summarize, Translate, Grammar Check, Explain
- Real-time message streaming with typing indicators
- Session-based chat history with SQLite persistence
- Customizable system prompts for specialized behavior
- Clean text processing with markdown and HTML sanitization

### Exam Paper Generator
- Automated question paper generation following SPPU 2019 pattern
- Support for three courses: Computer Engineering, Information Technology, AI & Data Science
- Year-wise subject selection (2nd, 3rd, 4th Year)
- Document upload support (PDF, DOC, DOCX, TXT) for syllabus context
- Configurable paper title, total marks, and duration
- Two-section paper format: Short theoretical (Q1-Q4) and Long answer (Q5-Q8)
- AI model: Mixtral-8x7B for document processing, GPT-OSS-120B for generation

### Document Summarizer
- Upload and process PDF, DOC, DOCX, and TXT files
- AI-powered intelligent summarization using Mixtral-8x7B
- Key point extraction and main idea identification
- Clean output formatting with markdown removal

### Code Assistant
- Multi-language code debugging and explanation
- Syntax error detection and correction suggestions
- Code optimization recommendations
- Step-by-step logic explanation

### Study Analytics Dashboard
- Circular progress indicator for daily prompt usage (20/day limit)
- Study streak tracking with fire icon visualization
- Recent chats quick access (last 3 sessions)
- Quick action shortcuts: Summarize, Translate, Grammar, Explain

### User Authentication & Profile
- Firebase Authentication with email/password
- User profile management with custom avatars
- Profile picture upload to Firebase Storage
- Username and bio customization
- Account settings and preferences

### Tools Suite
- Exam Customizer: AI-powered paper generation
- Assignment Helper: Document-based assignment assistance
- Code Assistant: Programming help and debugging
- Document Summarizer: PDF/DOC summarization
- Quiz Generator: Custom quiz creation
- Study Notes Builder: Note generation from content

### UI/UX Features
- Material Design 3 with dynamic color theming
- System, Light, and Dark mode support
- Custom Google Fonts integration
- Smooth page transitions and animations
- Bottom navigation with IndexedStack for performance
- Pull-to-refresh and loading states
- Responsive layouts for various screen sizes

---

## System Architecture

Quark follows the Model-View-Controller (MVC) architecture pattern for modularity and maintainability. The codebase is organized into distinct layers with clear separation of concerns.

### Directory Structure

```
lib/
├── main.dart                           # App entry point, theme configuration, MaterialApp setup
├── firebase_options.dart               # Auto-generated Firebase configuration
│
├── Controller/                         # Business Logic Layer (6 files)
│   ├── auth_controller.dart            # Firebase Authentication logic (7KB)
│   │   └── Sign-up, login, logout, password reset, session management
│   ├── database_controller.dart        # SQLite chat database operations (4KB)
│   │   └── Chat sessions, messages, prompt counting, recent sessions
│   ├── DB_Controller.dart              # SharedPreferences operations (1.6KB)
│   │   └── Streak tracking, last activity date, user preferences
│   ├── Firebase_Controller.dart        # Firebase Realtime Database operations (1KB)
│   │   └── Username fetch, profile sync, statistics upload
│   ├── groq_controller.dart            # Groq service wrapper (0.2KB)
│   │   └── Controller interface for AI services
│   └── groq_functions.dart             # Centralized AI functions (4.5KB)
│       └── GroqService class, ChatController, API configuration, text cleaning
│
├── Model/                              # Data Layer (2 files)
│   ├── chat_model.dart                 # Chat message data structure (0.2KB)
│   │   └── Message class with role, content, timestamp
│   └── user_model.dart                 # User profile data structure (2.2KB)
│       └── UserModel with id, email, username, avatar, preferences
│
├── View/                               # UI Layer (18 screens)
│   ├── splash_screen.dart              # App launch and initialization (4KB)
│   ├── login_screen.dart               # User authentication screen (6.7KB)
│   ├── signup_page.dart                # New user registration (16KB)
│   ├── dashboard.dart                  # Main home screen with stats (15.8KB)
│   ├── chat_screen.dart                # AI conversation interface (20KB)
│   ├── saved_chat_screen.dart          # Chat history browser (5.4KB)
│   ├── tools_screen.dart               # Tools grid with search (11.5KB)
│   ├── exam_customizer.dart            # Paper generator screen (26KB)
│   ├── generated_paper_screen.dart     # Paper viewer (7.8KB)
│   ├── document_summarizer_screen.dart # Doc summarization (8KB)
│   ├── code_assisstant_screen.dart     # Code helper interface (15.5KB)
│   ├── account_section_screen.dart     # Account management (17.9KB)
│   ├── profile_page.dart               # User profile editor (17.8KB)
│   ├── settings_page.dart              # App settings (6.8KB)
│   ├── about_us.dart                   # About page (10KB)
│   ├── prompt_history.dart             # Prompt history view (0.4KB)
│   ├── place(TEMP).dart                # Placeholder screen (0.5KB)
│   └── voice_temp                      # Voice assistant (experimental) (8.9KB)
│
├── Widgets/                            # Reusable Components (4 files)
│   ├── custom_drawer.dart              # Navigation drawer (5.3KB)
│   ├── chat_popup.dart                 # Chat customization popup (4.8KB)
│   ├── chat_history_drawer.dart        # History sidebar (4.5KB)
│   └── quark_logo.dart                 # Animated logo widget (1KB)
│
└── Settings/                           # App Configuration (2 files)
    ├── theme_data.dart                 # Light/Dark theme definitions (4.5KB)
    │   └── QuarkTheme class with color schemes, text styles, component themes
    └── font_data.dart                  # Google Fonts configuration
        └── Font family definitions and text theme setup
```

### Layer Responsibilities

**UI Layer (View)**
- 18 Flutter screens handling user interaction and navigation
- StatefulWidget-based state management with setState
- FutureBuilder for async data loading
- Material Design 3 components and custom widgets

**Business Logic Layer (Controller)**
- Authentication flow management
- Database CRUD operations
- API communication with Groq
- Local preference management

**Data Layer (Model)**
- Data class definitions with serialization
- Type-safe data structures
- JSON encoding/decoding for API communication

**Local Persistence Layer**
- SQLite database for chat sessions and messages
- SharedPreferences for user settings and streaks
- File system for cached documents

**Cloud Services Layer**
- Firebase Authentication for user identity
- Firebase Realtime Database for profile sync
- Firebase Storage for media uploads
- Groq API for AI inference

---

## Technology Stack

### Core Framework

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Framework | Flutter | 3.9+ | Cross-platform UI toolkit |
| Language | Dart | 3.9.2+ | Programming language |
| SDK | Flutter SDK | Latest stable | Development kit |

### Dependencies (Production)

| Package | Version | Category | Purpose |
|---------|---------|----------|---------|
| `flutter` | SDK | Core | Flutter framework |
| `firebase_core` | ^4.1.1 | Firebase | Firebase initialization and configuration |
| `firebase_auth` | ^6.1.0 | Firebase | User authentication (email/password) |
| `firebase_database` | ^12.0.2 | Firebase | Realtime Database for profile sync |
| `firebase_storage` | ^13.0.2 | Firebase | Cloud storage for profile pictures |
| `sqflite` | ^2.4.2 | Database | SQLite local database for chat history |
| `shared_preferences` | ^2.5.3 | Storage | Key-value storage for settings and streaks |
| `google_fonts` | ^6.3.2 | UI | Custom typography (Inter, Roboto, etc.) |
| `percent_indicator` | ^4.2.5 | UI | Circular progress indicators for stats |
| `syncfusion_flutter_gauges` | ^31.1.22 | UI | Advanced gauge widgets for analytics |
| `dotted_border` | ^3.1.0 | UI | Dotted border decorations for upload areas |
| `file_picker` | ^10.3.3 | Utility | Document selection (PDF, DOC, DOCX, TXT) |
| `image_picker` | ^1.2.0 | Utility | Camera and gallery image selection |
| `intl` | ^0.20.2 | Utility | Date/time formatting and internationalization |

### Dependencies (Development)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Unit and widget testing framework |
| `flutter_lints` | ^5.0.0 | Static analysis and linting rules |

### External APIs

| Service | Model | Purpose |
|---------|-------|---------|
| Groq API | GPT-OSS-120B | Primary chat completions and paper generation |
| Groq API | Mixtral-8x7B | Document processing and summarization |

### Build Configuration

| Setting | Value |
|---------|-------|
| Minimum SDK | Dart 3.9.2 |
| Material Design | Enabled |
| Assets Directory | `assets/` |
| Publish | Private (`publish_to: 'none'`) |

---

## Cloud Services Used

### Firebase Authentication
- **Purpose**: Secure user identity management
- **Features Used**: Email/password sign-up, sign-in, sign-out, password reset
- **Integration**: `firebase_auth` package with `AuthController` wrapper
- **Session Management**: Persistent login state across app restarts

### Firebase Realtime Database
- **Purpose**: Cloud synchronization of user data
- **Data Stored**: User profiles, usernames, usage statistics
- **Structure**: `/users/{uid}/` with profile fields
- **Sync Strategy**: Write-through on profile updates, read on app launch

### Firebase Storage
- **Purpose**: Media file storage
- **Usage**: Profile picture uploads and retrieval
- **Path Structure**: `/profile_pictures/{uid}/`
- **File Types**: JPEG, PNG images

### Groq API
- **Purpose**: AI-powered chat completions
- **Endpoint**: `https://api.groq.com/openai/v1/chat/completions`
- **Models Used**:
  - `openai/gpt-oss-120b`: Primary chat, paper generation (1500 tokens)
  - `mixtral-8x7b`: Document summarization (800 tokens)
- **Configuration**: Temperature 0.2-0.6, configurable max tokens
- **Rate Limiting**: Client-side 20 prompts/day limit

---

## Screenshots

Application UI previews and workflow screenshots:

| Screen | Description |
|--------|-------------|
| Splash Screen | App launch with Quark logo animation |
| Login | Email/password authentication |
| Sign Up | New user registration with validation |
| Dashboard | Home screen with stats, quick actions, recent chats |
| AI Chat | Conversation interface with message bubbles |
| Tools | 6-tool grid with search functionality |
| Exam Customizer | Course/subject selection, paper configuration |
| Generated Paper | Full-screen paper viewer with copy/share |
| Document Summarizer | File upload and AI summary display |
| Code Assistant | Code input with debugging response |
| Profile | Avatar, username, bio editing |
| Settings | Theme toggle, account options |

*Screenshots to be added*

---

## Installation & Setup

### Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Flutter SDK | 3.9+ | [Install Flutter](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.0+ | Included with Flutter |
| Android Studio | Latest | For Android development |
| Xcode | 14+ | For iOS development (macOS only) |
| Firebase Account | - | [Firebase Console](https://console.firebase.google.com) |
| Groq API Key | - | [Groq Console](https://console.groq.com) |

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/quark.git
cd quark
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

This will install all 14 production dependencies and 2 dev dependencies listed in `pubspec.yaml`.

### Step 3: Configure Firebase

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Click "Add Project" and follow setup wizard
   - Enable Google Analytics (optional)

2. **Enable Authentication**
   - Navigate to Authentication > Sign-in method
   - Enable "Email/Password" provider

3. **Enable Realtime Database**
   - Navigate to Realtime Database
   - Create database in production mode
   - Set security rules:
   ```json
   {
     "rules": {
       "users": {
         "$uid": {
           ".read": "$uid === auth.uid",
           ".write": "$uid === auth.uid"
         }
       }
     }
   }
   ```

4. **Enable Storage**
   - Navigate to Storage
   - Initialize with default settings
   - Set security rules:
   ```
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /profile_pictures/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

5. **Download Configuration Files**
   - **Android**: Download `google-services.json` → place in `android/app/`
   - **iOS**: Download `GoogleService-Info.plist` → place in `ios/Runner/`

### Step 4: Configure Groq API

1. Get your API key from [Groq Console](https://console.groq.com)

2. Update `lib/Controller/groq_functions.dart`:
   ```dart
   const String GROQ_API_KEY = 'gsk_your_api_key_here';
   ```

### Step 5: Run the Application

```bash
# Development mode
flutter run

# Specify device
flutter run -d <device_id>

# List available devices
flutter devices
```

### Build for Production

```bash
# Android APK (universal)
flutter build apk --release

# Android APK (split by ABI for smaller size)
flutter build apk --split-per-abi --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS and Xcode)
flutter build ios --release
```

### Verify Installation

After successful build, you should see:
- Splash screen with Quark logo
- Login screen with email/password fields
- Successful Firebase connection (check console logs)

---

## Project Statistics

| Metric | Value |
|--------|-------|
| Total Dart Files | 32 |
| View Screens | 18 |
| Controllers | 6 |
| Models | 2 |
| Widgets | 4 |
| Settings Files | 2 |
| Total Source Size | ~200 KB |
| Dependencies | 14 production, 2 dev |

---

## Contributing

Contributions to Quark are welcome. Please follow these guidelines:

### Getting Started

1. **Open an Issue**: Discuss the proposed feature or bug fix before starting work
2. **Fork the Repository**: Create your own copy to work on
3. **Create Feature Branch**: `git checkout -b feature/YourFeature`
4. **Make Changes**: Implement your feature or fix
5. **Test Thoroughly**: Ensure all existing functionality works
6. **Submit Pull Request**: Include clear description of changes

### Code Standards

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain MVC architecture separation
- Keep widgets modular and reusable

### Commit Messages

- Use present tense: "Add feature" not "Added feature"
- Be descriptive but concise
- Reference issue numbers when applicable

### Pull Request Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] No new warnings or errors
- [ ] Tested on Android and iOS (if applicable)
- [ ] Documentation updated if needed

---

## Contact

**Developer**: Your Name  
**Email**: your.email@example.com  
**GitHub**: [@yourusername](https://github.com/yourusername)  
**LinkedIn**: [Your Profile](https://linkedin.com/in/yourprofile)

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

---

<p align="center">Made with Flutter 💙</p>
