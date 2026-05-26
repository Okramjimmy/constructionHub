# ConstructionHub 🏗️

A state-of-the-art Flutter mobile and web application designed for enterprise construction quality control and field inspections. Built with premium aesthetics, rich transitions, and advanced custom features, it delivers an exceptional user experience on **iOS, Android, and Web**.

---

## 📱 Features & Workspaces

The application implements a robust suite of tools tailored for construction project managers and quality control engineers:
1. **Secure Enterprise Authentication**: Secure SSO login with beautiful fade-in animations, biometric placeholders, and loading states.
2. **Command Hub Dashboard**: Real-time project statistics (active sites, pass rate, inspections) paired with an intuitive 2×2 interactive grid.
3. **Projects Portal**: Live-search filtered list of construction sites complete with dynamic custom-painted grid map thumbnails and status badges.
4. **Project Sub-Types**: Interactive stage tracker across disciplines (Civil, Finishing, MEP, HSE) with detailed checklist progress indicators.
5. **Daily Inspection Checklist**: Beautiful inspection engine with progress bars, animated pass/fail status switches, capture notes, and sticky submission.
6. **AI Defect Processor**: Animated pipeline showcasing uploading, analyzing, and reporting site imagery (cracks, honeycombing) with circular gauge meters.
7. **Image Annotation Canvas**: Dark-themed interactive workspace featuring bounding boxes, freehand drawing brushes, undo stacks, and dynamic color pickers.

---

## 🛠️ Technology Stack & Architecture

- **Core Framework**: [Flutter SDK](https://flutter.dev) (Stable Channel)
- **State Management**: [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) (Unidirectional data flows, robust provider caching)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (Declarative, URL-based routing, smooth route parameters)
- **Typography & Aesthetics**: Google Fonts ([Sora](https://fonts.google.com/specimen/Sora) for headers, [IBM Plex Mono](https://fonts.google.com/specimen/IBM+Plex+Mono) for metadata)
- **Layout System**: Fully custom Vanilla CSS-inspired layout tokens and responsive adaptions.

---

## ⚙️ Prerequisites & System Requirements

Before running or building the app, make sure your development environment meets the following requirements:

### 1. General Setup
* **Flutter SDK**: `v3.19.0` or higher (Stable channel).
* **Dart SDK**: Automatically bundled with Flutter.
* **Operating System**: 
  * **macOS**: Required to build/run for **iOS** and **macOS**.
  * **Windows / Linux**: Supports building/running for **Android** and **Web**.

### 2. Android Requirements
* **Android Studio**: Installed with the latest Android SDK.
* **Android SDK Command-line Tools**: Installed via Android Studio SDK Manager (`Tools > SDK Manager > SDK Tools`).
* **Java Development Kit (JDK)**: **JDK 17** is required.
* **Android Virtual Device (AVD)**: Set up an emulator running Android 11.0 (API 30) or higher.

### 3. iOS Requirements (macOS Only)
* **Xcode**: `v15.0` or higher.
* **CocoaPods**: Xcode dependency manager.
  * Install via Homebrew (recommended): `brew install cocoapods`
  * Or via RubyGems: `sudo gem install cocoapods`
* **iOS Simulator**: Set up via Xcode (`Xcode > Settings > Platforms`).

### 4. Web Requirements
* **Google Chrome**: Installed on the development machine.

---

## 🚀 Step-by-Step Installation & Setup

Follow these steps to set up the codebase on your local machine:

1. **Clone the Git Repository**:
   ```bash
   git clone https://github.com/Okramjimmy/constructionHub.git
   cd constructionHub
   ```

2. **Verify your Flutter installation**:
   ```bash
   flutter doctor
   ```
   Ensure that the target platforms (Android, iOS, or Web) show green checkmarks.

3. **Fetch project dependencies**:
   ```bash
   flutter pub get
   ```

4. **Verify the code passes static analysis**:
   ```bash
   flutter analyze
   ```

---

## 💻 Running the Application

### 1. Running on macOS Desktop (Native — HIGHLY RECOMMENDED)
Because the backend uses HTTP-only `erp_session` cookies with `SameSite=Lax` guidelines, modern browser engines may restrict cross-origin cookie storage when running the web client locally on `localhost:8080` against the remote backend IP. 
Running as a **native macOS Desktop app** completely bypasses all CORS, cookie, and SameSite blocks! It utilizes a local standalone persistent jar store (`PersistCookieJar` + `FileStorage`) which works instantly and flawlessly.
```bash
# Run as a native macOS app
flutter run -d macOS
```

### 2. Running on Web (Google Chrome)
If you wish to test in Chrome, you must override Chrome's default cross-origin cookie security and SameSite engine during local dev:
```bash
# Run on Chrome with CORS & SameSite disabled
flutter run -d chrome \
  --web-browser-flag="--disable-web-security" \
  --web-browser-flag="--disable-features=SameSiteByDefaultCookies,CookiesWithoutSameSiteMustBeSecure"
```

### 3. Running on iOS Simulator (macOS Only)
1. Start the iOS Simulator:
   ```bash
   open -a Simulator
   ```
2. Once the simulator starts, run the app:
   ```bash
   flutter run -d iphonesimulator
   ```

### 4. Running on Android Emulator
1. Start your Android Emulator via Android Studio Device Manager.
2. Verify Flutter detects the running emulator:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run
   ```

---

## 🔄 Refreshing & Applying New Updates

When a new update is released or modifications are pushed to the remote repository, refresh your environment with the following checklist to ensure zero state mismatches:

### 1. Fetch & Pull New Code
```bash
# Pull the latest changes from the main branch
git pull origin main
```

### 2. Flush Caches & Rebuild Dependencies
If libraries or assets were changed in `pubspec.yaml`, clean the cache and fetch fresh packages:
```bash
# Clear all build caches and temporary packages
flutter clean

# Re-fetch all clean Dart dependencies
flutter pub get
```

### 3. Hot Session Keys during Development
When running a live debug session in your terminal, use the keyboard shortcuts to sync changes:
* **`r` (Hot Reload)**: Injects updated source code files directly into the VM. The app state is fully preserved, letting you see style or layout tweaks instantly (takes less than 1 second).
* **`R` (Hot Restart)**: Rebuilds the widgets from scratch and runs `main()`. Use this when adding new providers, changing routes, or initializing static configs.

---

## 📦 Building for Production

When you are ready to compile the application for deployment or distribution, use the following build commands:

### 1. Compiling for Web
Generates static assets (HTML, JS, CSS, assets) in the `build/web/` directory.
```bash
flutter build web --release
```
* **Deployment**: You can host the contents of `build/web/` directly on Firebase Hosting, Netlify, Vercel, AWS S3, or any static web host.

### 2. Compiling for Android
Generates release builds in the `build/app/outputs/`.

* **Generate an APK (for direct testing & manual installation)**:
  ```bash
  flutter build apk --release
  ```
  * Output: `build/app/outputs/flutter-apk/app-release.apk`

* **Generate an Android App Bundle (AAB - for Google Play Store upload)**:
  ```bash
  flutter build appbundle --release
  ```
  * Output: `build/app/outputs/bundle/release/app-release.aab`

### 3. Compiling for iOS (macOS Only)
Prepares the application package for Apple App Store Connect distribution.
```bash
flutter build ipa --release
```
* Output: `build/ios/archive/Runner.xcarchive` and `build/ios/ipa/Runner.ipa`
* **Note**: This step requires valid Xcode provisioning profiles and distribution certificates.

---

## ⚠️ Troubleshooting & Common Issues

### ❌ Android JDK/SDK issues
* **Symptom**: Gradle fails to run or complains about JDK mismatch.
* **Solution**: Ensure your environment variables point to Java 17.
  * In macOS/Linux `~/.zshrc` or `~/.bashrc`:
    ```bash
    export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    ```
  * Verify by running `java -version`.

### ❌ iOS CocoaPods Dependency errors
* **Symptom**: Xcode build fails with `Podfile` or `CocoaPods` missing warnings.
* **Solution**:
  ```bash
  cd ios
  pod repo update
  pod install
  cd ..
  flutter clean
  flutter pub get
  ```

### ❌ Flutter Web White Screen or Asset Loading
* **Symptom**: Web builds show a white screen on startup.
* **Solution**: Inspect the Chrome Developer Console (`F12`). If you see root path errors, make sure you configure your base href if deploying to a subdirectory:
  ```bash
  flutter build web --base-href="/my-sub-directory/"
  ```

---

## 🤝 Need Support?
Use the standard Flutter diagnostic utility to inspect your developer workstation:
```bash
flutter doctor -v
```
Enjoy building with **ConstructionHub**! 🏗️
