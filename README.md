# NEET Aspirants Community

> Practice every day. Clear doubts with AI. Track preparation. Prepare smarter for NEET UG.

A free, AI-powered digital community and preparation ecosystem for NEET UG aspirants. This monorepo houses the cross-platform mobile application, student web portal, backend API, and GenAI services.

---

## 🚀 Active Feature Highlight: HSR-66 (Mobile Auth — Forgot & Reset Password)

> **Task Completed for Review**: Complete end-to-end mobile password recovery and reset flow built for **Android** and **iOS** with custom animations, live input validation, interactive OTP verification, and password security policies.

### Flow Summary
```
Login Screen (/login)
   │
   ▼ [Tap "Forgot password?"]
1. Forgot Password (/forgot-password)
   │  • Authentic student illustration with floating levitating key animation
   │  • NEET Community header typography (#1E2640)
   │  • Real-time email validation regex (enables "Send OTP")
   ▼
2. Verify OTP (/verify-otp)
   │  • Clean application border container (#E2EAF5, radius 28px)
   │  • 6 auto-advancing Circle Outline OTP input fields
   │  • Auto-focus, backspace navigation, and clipboard paste support
   │  • 30-second resend countdown timer with automatic re-enable
   │  • Demo Mode Tip Card (Demo OTP: 123456)
   ▼
3. Reset Password (/reset-password)
   │  • Password & Confirm Password with visibility eye toggle
   │  • Real-time 5-point security checklist (8+ chars, uppercase, lowercase, number, symbol)
   │  • Real-time match / mismatch validation badge
   │  • "Reset Password" button automatically unlocks when all criteria pass
   ▼
4. Password Reset Success (/password-reset-success)
   │  • Signature Coral-Pink gradient checkmark badge
   │  • Bouncy celebratory spring pop-up entrance animation (Curves.elasticOut)
   │  • Radiant confetti burst (stars, dots, ribbons in coral, gold, mint, and periwinkle)
   │  • "Back to Login" action button returning cleanly to /login
```

---

## 📱 How to Run the Mobile App (Android & iOS)

### 1. Prerequisites
- **Flutter SDK**: `>=3.19.0` (with Dart `>=3.3.0`)
- **Android**: Android Studio with Android SDK and an Android Virtual Device (Emulator), or an Android phone with USB Debugging enabled.
- **iOS**: macOS machine with Xcode installed (required by Apple to run the iOS Simulator).

### 2. Quick Run Instructions
All mobile commands must be executed from inside `apps/mobile`:

```bash
# 1. Navigate to the mobile package
cd apps/mobile

# 2. Setup environment configuration
cp .env.example .env

# 3. Fetch dependencies
flutter pub get

# 4. Check available target devices
flutter devices

# 5. Launch Android Emulator (or connect your device)
flutter emulators --launch Pixel_7

# 6. Run the application
flutter run
```

### 3. Platform Support (Android vs. iOS)

The codebase is built with 100% platform-agnostic Flutter and Dart code, designed to compile and run identically on both platforms:

| Platform | Windows Machine | macOS Machine | CI/CD (GitHub Actions / Codemagic) |
| :--- | :---: | :---: | :---: |
| **Android** | ✅ Runs via Android Emulator / Physical Device | ✅ Runs via Android Emulator / Physical Device | ✅ Fully Supported |
| **iOS** | ⚠️ Code & native `ios/` runner ready (*Apple restricts Xcode & Simulator to macOS*) | ✅ Runs via iOS Simulator / iPhone | ✅ Fully Supported |

> **Note for Reviewers on Windows**: Apple strictly restricts **Xcode** and the **iOS Simulator** to **macOS**. Because of Apple's OS licensing lock, iOS emulators cannot run on Windows. However, all Flutter code, native iOS project files (`apps/mobile/ios/`), `SafeArea` insets, touch targets ($\ge 48\text{ dp}$), and Cupertino keyboard scrolling are fully configured. Opening this repository on any macOS machine allows running `flutter run -d ios` immediately with zero code changes.

### 4. Running Automated Tests & Code Quality
```bash
cd apps/mobile

# Run the complete test suite (14 automated tests)
flutter test --no-pub

# Verify zero lint warnings and static analysis errors
flutter analyze
```
* **Test Suite Status**: **14/14 automated tests passing** (Email validation, 6-digit OTP verification, clipboard paste, resend timer, 5-point password checklist, confirm password validation, and end-to-end multi-screen navigation flow).
* **Static Analysis**: **0 issues found**.

---

## 📁 Repository Layout

This is a polyglot monorepo. Each app owns its dependencies and can be run independently:

```
NEET-Community/
├── apps/
│   ├── mobile/       # Flutter 3.x App (Android & iOS) — Riverpod, GoRouter, Material 3
│   ├── web/          # Student Dashboard — React 18 + Vite + TS + Tailwind + Ant Design
│   └── backend/      # REST API — Node.js 20 + Express + TypeScript + MongoDB (Mongoose)
├── services/
│   └── ml/           # GenAI & ML — Python 3.11 (prompts, evals, RAG, guardrails)
├── docs/             # Architecture, workflow, onboarding, Linear tickets, PR/branch rules
├── .github/          # PR template, issue templates, CI workflows
├── .editorconfig
├── .nvmrc
├── .gitignore
└── README.md
```

Each app contains its own dedicated `README.md` with in-depth instructions:
- [apps/mobile/README.md](apps/mobile/README.md) *(Detailed mobile architecture, widgets, and animation design)*
- [apps/web/README.md](apps/web/README.md)
- [apps/backend/README.md](apps/backend/README.md)
- [services/ml/README.md](services/ml/README.md)

---

## 🛠 Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Mobile** | Flutter 3.x, Dart 3.x, Riverpod (StateNotifier), GoRouter, Dio |
| **Web Frontend** | React 18, Vite, TypeScript, Tailwind CSS, Ant Design |
| **State / Data** | React Query (server state), Zustand (UI state) |
| **Backend API** | Node.js 20, Express, TypeScript, Mongoose ODM |
| **Database** | MongoDB 6+ (local or Atlas) |
| **Authentication** | JWT (access + refresh tokens), BCrypt hashing |
| **GenAI / ML** | Python 3.11, Provider-agnostic LLM wrapper, Pydantic, Sentence-Transformers |
| **CI / CD** | GitHub Actions |
| **Project Tracking** | Linear |

---

## ⚡ Development Workflow

1. Pick an assigned Linear ticket (e.g., `HSR-66`).
2. Create a feature branch off `develop`: `git checkout -b hsr-66-forgot-password-reset-password`.
3. Follow Conventional Commits: `feat(mobile): add circle outline otp input and success pop-up animation`.
4. Ensure tests and static analysis pass before opening PR:
   ```bash
   cd apps/mobile
   flutter analyze
   flutter test --no-pub
   ```
5. Open PR into `develop` referencing the ticket.

---

## 📖 Key Documentation Links

- [Mobile Documentation (Detailed)](apps/mobile/README.md)
- [Product Context & PRD](docs/PRODUCT_CONTEXT.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Git Workflow & Branch Rules](docs/GIT_WORKFLOW.md)
- [Linear Tickets](docs/LINEAR_TICKETS.md)
- [API Contract & Conventions](docs/API_CONTRACT.md)

---

## 👥 Team & Ownership

| Role | Contact |
| :--- | :--- |
| **Project Lead / PM** | Himanshu Raj (`himanshu@myaifrontdesk.com`) |
| **Feature Lead / Mobile** | Task `HSR-66` — Branch `hsr-66-forgot-password-reset-password` |

---

## 📄 License
Proprietary — Internal use for NEET Aspirants Community.
