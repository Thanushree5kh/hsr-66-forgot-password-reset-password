# NEET Community — Mobile (Sushruta)

Cross-platform mobile application built with **Flutter 3.x** and **Dart** for **Android** and **iOS**.

---

## Table of Contents

1. [Quick Start & Running the App](#quick-start--running-the-app)
2. [Platform Support (Android & iOS)](#platform-support-android--ios)
3. [Feature Documentation: HSR-66 — Forgot & Reset Password](#feature-documentation-hsr-66--forgot--reset-password)
4. [Custom Animations & Interactive Elements](#custom-animations--interactive-elements)
5. [Architecture & Design System](#architecture--design-system)
6. [Directory Structure](#directory-structure)
7. [Testing & Quality Assurance](#testing--quality-assurance)
8. [Troubleshooting & FAQs](#troubleshooting--faqs)

---

## Quick Start & Running the App

### 1. Prerequisites
- **Flutter SDK**: `>=3.19.0`
- **Dart SDK**: `>=3.3.0 <4.0.0`
- **Android**: Android Studio with an Android Emulator or physical device with USB debugging enabled.
- **iOS**: macOS machine with Xcode installed (required by Apple to run the iOS Simulator).

### 2. Steps to Run

> **Important**: All mobile commands must be run from inside the `apps/mobile` directory, where `pubspec.yaml` is located.

```powershell
# 1. Navigate to the mobile folder
cd apps/mobile

# 2. Setup environment file
cp .env.example .env

# 3. Install dependencies
flutter pub get

# 4. Check available devices
flutter devices

# 5. Launch Android Emulator (if not already running)
flutter emulators --launch Pixel_7

# 6. Run the application
flutter run
```

---

## Platform Support (Android & iOS)

The codebase is built with 100% platform-agnostic Flutter and Dart code designed to compile and run identically on both platforms:

| Platform | Windows Dev Machine | macOS Dev Machine | CI/CD (GitHub Actions / Codemagic) |
| :--- | :---: | :---: | :---: |
| **Android** | ✅ Runs via Android Emulator / USB Device | ✅ Runs via Android Emulator / USB Device | ✅ Supported |
| **iOS** | ⚠️ Code & native files ready (cannot run locally on Windows due to Apple OS lock) | ✅ Runs via iOS Simulator / iPhone | ✅ Supported |

### Why iOS doesn't show in `flutter devices` on Windows:
- Apple strictly restricts **Xcode** and the **iOS Simulator** to **macOS**. 
- The Flutter codebase contains the native `ios/` runner and follows Apple Human Interface Guidelines (HIG) with `SafeArea`, adaptive touch targets ($\ge 48\times48\text{ dp}$), and iOS keyboard inset scrolling.
- When this project is opened on any Mac machine, `flutter devices` will automatically discover the iOS Simulator, and `flutter run` will run directly on iPhone with zero code modifications.

---

## Feature Documentation: HSR-66 — Forgot & Reset Password

Complete end-to-end mobile password recovery and reset flow for Sushruta.

### Flow Diagram

```
Existing Login (/login)
       │
       ▼ [Tap "Forgot password?"]
Forgot Password Screen (/forgot-password)
       │  • Authentic student illustration with floating levitating key animation
       │  • NEET Community header typography (#1E2640)
       │  • Email input with live regex validation (enables "Send OTP")
       ▼
OTP Verification Screen (/verify-otp)
       │  • Clean application border container (#E2EAF5, radius 28px)
       │  • 6 auto-advancing Circle Outline OTP input fields
       │  • Masked email display (e.g. k*@gmail.com)
       │  • 30-second countdown timer for Resend OTP
       │  • Demo Mode Tip Card (Demo OTP: 123456)
       ▼
Reset Password Screen (/reset-password)
       │  • New Password & Confirm Password with visibility toggle
       │  • Live 5-point security checklist (8+ chars, uppercase, lowercase, number, symbol)
       │  • Real-time match / mismatch validation badge
       │  • Reset button automatically enables when all criteria pass
       ▼
Password Reset Success Screen (/password-reset-success)
       │  • Signature Coral-Pink gradient checkmark badge
       │  • Bouncy celebratory spring pop-up entrance animation (Curves.elasticOut)
       │  • Radial confetti burst of ribbons, stars, and dots in coral, gold, mint, and periwinkle
       ▼ [Tap "Back to Login"]
Existing Login (/login)
```

### Screens & Components Built

1. **Forgot Password Screen (`lib/screens/forgot_password_screen.dart`)**
   - **Hero Illustration** (`lib/widgets/forgot_password_hero.dart`):
     - Authentic high-resolution student artwork with cloud backdrop and study desk.
     - **Dynamic Levitating Key**: Coral key held at his fingertips that smoothly glides outward and upward into the air, hovers at peak levitation with glowing radiant aura and sparkle rays, and glides back into his grip in a continuous cycle.
     - **Animated Physics Atom**: Top-right doodle with 3 orbital rings and orbiting electron dots.
     - **Botanical Sprig**: Bottom-right mint leaves with gentle live swaying motion.
   - **NEET Community Logo** (`lib/widgets/neet_logo.dart`):
     - Bold "NEET" and "Community" styled in `#1E2640` (matching screen heading typography).
     - ECG heartbeat pulse wave connecting the words.
     - Subtitle "Learn • Discuss • Grow Together".
   - **Real-Time Email Validation**:
     - Disables "Send OTP" when empty.
     - Displays validation helper error if format is invalid.
     - Enables button when email is valid.

2. **OTP Verification Screen (`lib/screens/otp_verification_screen.dart`)**
   - **Application Border Container**:
     - Rounded container card with soft border (`#E2EAF5`, radius `28px`) and subtle elevation shadow on `AppColors.background`.
     - Completely stationary layout without distracting wave motion.
   - **Circle Outline OTP Fields** (`lib/widgets/otp_input.dart`):
     - 6 individual circular input outlines (`46 × 46px`, `BorderRadius.circular(23)`).
     - Auto-focuses the first field on mount.
     - Automatically advances focus to the next circle upon digit entry.
     - Full backspace navigation (clears and focuses previous circle).
     - Full paste support (pasting a 6-digit code populates all 6 circles).
     - Bold centered digits with soft blue focus highlight ring.
   - **Resend Countdown Timer**:
     - 30-second countdown with automatic re-enable.
   - **Tip Card (Demo Mode)**:
     - Clear notice displaying `Demo OTP: 123456` for instant evaluation without backend dependency.

3. **Reset Password Screen (`lib/screens/reset_password_screen.dart`)**
   - **`PasswordField`** (`lib/widgets/password_field.dart`):
     - Password input field with show/hide password visibility toggle.
   - **`PasswordRequirementsWidget`** (`lib/widgets/password_requirements.dart`):
     - Live 5-point security validation checklist that updates in real time as the user types:
       1. At least 8 characters
       2. One uppercase letter (A-Z)
       3. One lowercase letter (a-z)
       4. One number (0-9)
       5. One special character (`!@#$%^&*...`)
     - Satisfied rules display a green checkmark; unsatisfied rules remain muted/grey.
   - **Real-Time Confirm Password Validation**:
     - Match / mismatch badge with dynamic feedback ("Passwords match." vs "Passwords do not match.").
   - "Reset Password" button remains disabled until all 5 checklist items are satisfied AND passwords match.

4. **Password Reset Success Screen (`lib/screens/password_reset_success_screen.dart`)**
   - **Pink / Coral Gradient Checkmark Badge**:
     - Signature Coral-Pink gradient circle (`#FFFF7E6B` to `#FFFF4848`).
     - Soft blush pink outer pulse halo (`#FFFFEBE9`).
     - Twinkling golden star accent.
   - **Celebratory Pop-Up Animation**:
     - Bouncy spring entrance using `Curves.elasticOut`.
     - Radial burst of celebratory confetti ribbons, stars, and dots in coral, gold, mint, and periwinkle.
   - "Back to Login" action button that clears temporary state and routes to `/login`.

---

## Architecture & Design System

### Layered Architecture

```
Presentation Layer (UI Screens & Reusable Widgets)
       │
       ▼
State Management (Riverpod StateNotifier: PasswordResetNotifier)
       │
       ▼
Data Layer (PasswordResetRepository Interface)
       ├── DioPasswordResetRepository (Production: POST /api/auth/...)
       └── MockPasswordResetRepository (Offline & Automated Test Mode)
```

- **State Management**: `flutter_riverpod` manages state cleanly through immutable state models (`PasswordResetState`, `PasswordCriteria`).
- **Navigation**: `go_router` manages declarative URL routes (`/login`, `/forgot-password`, `/verify-otp`, `/reset-password`, `/password-reset-success`).
- **HTTP Client**: `Dio` with custom interceptors for token attachment and clean error mapping.
- **Repository Pattern**: Strict separation between interface and implementations:
  - `DioPasswordResetRepository`: Pre-wired for backend endpoints (`POST /api/auth/forgot-password`, `POST /api/auth/verify-otp`, `POST /api/auth/reset-password`).
  - `MockPasswordResetRepository`: Isolated implementation allowing full visual and functional testing while backend auth endpoints are in development (`Demo OTP: 123456`).
- **Design System**: Material 3 styling adhering to the design palette:
  - `AppColors.primary`: `#EB5757` (Coral Red)
  - `AppColors.textPrimary`: `#1E2640` (Deep Navy / Charcoal)
  - `AppColors.textSecondary`: `#677489` (Muted Cool Slate)
  - `AppColors.background`: `#F0F5FA` (Soft Sky / Calm backdrop)

---

## Directory Structure

```
apps/mobile/
├── android/                         # Native Android host project
├── ios/                             # Native iOS host project
├── assets/images/                   # Cleaned high-res artwork & transparent assets
├── lib/
│   ├── main.dart                    # App entry point (loads .env & ProviderScope)
│   ├── app.dart                     # MaterialApp.router & GoRouter configuration
│   ├── models/
│   │   └── password_reset_models.dart    # Password criteria & reset state classes
│   ├── providers/
│   │   └── password_reset_provider.dart  # Riverpod StateNotifier & timers
│   ├── services/
│   │   ├── api_client.dart               # Dio HTTP client & secure storage
│   │   └── password_reset_service.dart   # Repository interface, Dio & Mock repos
│   ├── screens/
│   │   ├── login_screen.dart             # Login screen with Forgot Password entrypoint
│   │   ├── forgot_password_screen.dart   # Screen 1: Email entry & Send OTP
│   │   ├── otp_verification_screen.dart  # Screen 2: 6 Circle OTP & Resend Timer
│   │   ├── reset_password_screen.dart    # Screen 3: New Password & Live Checklist
│   │   └── password_reset_success_screen.dart # Screen 4: Success confirmation & pop-up
│   ├── widgets/
│   │   ├── forgot_password_hero.dart     # Hero illustration with floating key physics
│   │   ├── neet_logo.dart                # NEET Community logo with ECG heartbeat wave
│   │   ├── otp_input.dart                # 6 Circle Outline OTP component
│   │   ├── password_field.dart           # Password input with visibility toggle
│   │   └── password_requirements.dart    # Reusable live 5-rule checklist widget
│   └── theme/
│       └── theme.dart                    # Material 3 light theme definitions & palette
├── test/
│   ├── password_reset_test.dart     # Comprehensive test suite (14 tests)
│   └── widget_test.dart             # Smoke test
├── pubspec.yaml                     # Dependencies & assets configuration
└── .env                             # Environment variables (API base URL)
```

---

## Testing & Quality Assurance

### Run Automated Tests
```powershell
flutter test --no-pub
```
All **14 automated tests** pass:
- ✅ 1. Email criteria validation regex
- ✅ 2. Send OTP button disabled for empty / invalid email
- ✅ 3. Send OTP button enabled for valid email
- ✅ 4. OTP requires exactly 6 digits (button disabled until all 6 entered)
- ✅ 5. OTP paste behavior populates all 6 boxes
- ✅ 6. Resend OTP countdown timer behavior (30 seconds)
- ✅ 7. Password minimum 8 characters validation
- ✅ 8. Uppercase letter requirement validation
- ✅ 9. Lowercase letter requirement validation
- ✅ 10. Number requirement validation
- ✅ 11. Special character requirement validation
- ✅ 12. Confirm password mismatch validation
- ✅ 13. Confirm password match validation & Reset button enabled/disabled
- ✅ 14. Complete end-to-end navigation flow between all HSR-66 screens

### Code Analysis
```powershell
flutter analyze
```
Result: **0 errors, 0 warnings, 0 lint issues**.

---

## Troubleshooting & FAQs

### Q: `Error: No pubspec.yaml file found`
**Cause:** The command was run from the root `NEET-Community` directory instead of the Flutter app directory.  
**Fix:** Run `cd apps/mobile` before executing any `flutter` commands.

### Q: `flutter devices` does not show Android
**Cause:** No emulator is booted or no physical device is connected.  
**Fix:** Launch the emulator with `flutter emulators --launch Pixel_7`. Once booted, run `flutter devices` again.

### Q: Why does `flutter devices` not show iOS on Windows?
**Cause:** Apple restricts Xcode and the iOS Simulator exclusively to macOS. It is not possible to run iOS simulators on a Windows PC.  
**Fix:** The code and native `ios/` folder are 100% cross-platform. To build/test iOS, clone the repository on any Mac and run `flutter run`.

### Q: How do I test the full flow without a backend server?
**Fix:** The app runs in Demo Mode by default with `MockPasswordResetRepository`. On the OTP verification screen, enter Demo OTP: **`123456`**.
