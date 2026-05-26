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

1. **Verify your Flutter installation**:
   ```bash
   flutter doctor
   ```
   Ensure that the target platforms (Android, iOS, or Web) show green checkmarks.

2. **Navigate to the project root**:
   ```bash
   cd /Users/okrammeitei/Projects/ConstructionHub
   ```

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

### 1. Running on Web (Google Chrome)
The web platform is ideal for quick testing and does not require emulator configurations.
```bash
# Run on Chrome
flutter run -d chrome

# Run on a specific port (e.g. 8080) for predictable local URLs
flutter run -d chrome --web-port=8080
```

### 2. Running on Android

#### Using an Emulator (Virtual Device)
1. Open Android Studio, navigate to **Device Manager**, and start your preferred Android Virtual Device (AVD).
2. Verify Flutter detects the running emulator:
   ```bash
   flutter devices
   ```
3. Run the app:
   ```bash
   flutter run -d <emulator_id> # or simply 'flutter run' if only one device is active
   ```

#### Using a Physical Android Device
1. Enable **Developer Options** on your Android device (Go to `Settings > About phone` and tap `Build number` 7 times).
2. Enable **USB Debugging** in Developer Options.
3. Connect the phone to your computer via USB cable.
4. Run:
   ```bash
   flutter run
   ```

---

### 3. Running on iOS (macOS Only)

#### Using a Simulator (Virtual Device)
1. Start the simulator from your terminal:
   ```bash
   open -a Simulator
   ```
2. Once the simulator boots, run:
   ```bash
   flutter run
   ```

#### Using a Physical iOS Device
1. Connect your iPhone/iPad to your Mac via USB.
2. On your iPhone, enable **Developer Mode** (`Settings > Privacy & Security > Developer Mode` - requires device restart).
3. Open the iOS project in Xcode to configure code signing:
   ```bash
   open ios/Runner.xcworkspace
   ```
4. In Xcode, select the `Runner` target on the left side, go to the **Signing & Capabilities** tab, and select your Apple Developer account/team.
5. In your terminal, run:
   ```bash
   flutter run -d <device_id>
   ```

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
Generates release builds in the `build/app/outputs/` directory.

* **Generate an APK (for testing & direct installation)**:
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
