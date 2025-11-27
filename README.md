# Kotlin App with Flutter Module

A hybrid Android application demonstrating native Kotlin integration with a Flutter module. The app features a login flow with UUID-based session management and a product catalog powered by Flutter.

## Architecture Overview

### Native Android (Kotlin)
- **MainActivity**: Entry point that checks for cached UUID and launches Flutter module
- **LoginFragment**: Handles user authentication and UUID generation
- **Navigation**: Uses Android Navigation Component for fragment navigation

### Flutter Module
- **State Management**: Riverpod
- **Networking**: Dio with interceptors for logging and UUID headers
- **Architecture**: Clean architecture with Domain, Data, and Presentation layers
- **Routing**: GoRouter for navigation
- **API**: FakeStore API for product data

## Features

### 1. UUID-Based Session Management
- On first launch, users see the login screen
- After successful login, a UUID is generated and cached
- On subsequent launches, the app bypasses login and directly loads the Flutter module

### 2. Flutter Product Catalog
- **List Page**: Displays products from FakeStore API
- **Detail Page**: Shows product details with a "Pay" button
- **Native Communication**: Pay button sends product data back to native Android via MethodChannel

### 3. Theming
- Supports light/dark theme modes
- Configurable primary colors
- Theme configuration passed from native to Flutter

## Project Structure

```
KotlinApp/
├── app/                         
│   └── src/main/
│       ├── java/com/kotlin/kotlinapp/
│       │   ├── MainActivity.kt
│       │   ├── FlutterFragment.kt
│       │   ├── FlutterBridgeActivity.kt
│       │   └── LoginFragment.kt
│       └── res/
│           ├── layout/
│           └── navigation/
└── flutter_module/               
    └── lib/
        ├── main.dart
        ├── core/
        │   └── network.dart
        ├── models/
        │   ├── app_config.dart
        │   └── product.dart
        ├── pages/
        │   ├── product_detail_page.dart
        │   └── product_list_page.dart
        ├── services/
        │   ├── api_service.dart
        │   └── native_bridge.dart
        └── features/
            └── products/
                ├── data/
                │   └── product_repository.dart
                ├── domain/
                │   └── product.dart
                └── presentation/
                    ├── providers.dart
                    ├── product_list_screen.dart
                    └── product_detail_screen.dart
```

## Setup Instructions

### Prerequisites
- Android Studio
- Flutter SDK (3.6.1 or higher)
- JDK 8 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/bhumika2080/ecommerce-app
   cd KotlinApp
   ```

2. **Install Flutter dependencies**
   ```bash
   cd flutter_module
   flutter pub get
   cd ..
   ```

3. **Build the project**
   - Open the project in Android Studio
   - Sync Gradle files
   - Build and run the app

### Running the App

1. **First Launch**
   - App displays the login screen
   - Enter any username and password (basic validation only)
   - App generates a UUID and launches the Flutter module

2. **Subsequent Launches**
   - App automatically launches the Flutter module
   - To reset: Clear app data or uninstall/reinstall

## Configuration

### App Configuration (Native → Flutter)
The native app can pass configuration to Flutter via Intent extras:

```kotlin
intent.putExtra("uuid", uuid)
intent.putExtra("themeMode", "dark") // "light" | "dark" | "system"
intent.putExtra("primaryColor", "#FF6200EE")
```

### API Configuration
The Flutter module uses FakeStore API by default. To change the API:

1. Open `flutter_module/lib/core/network.dart`
2. Update the `baseUrl` in the Dio configuration

## Key Dependencies

### Android
- Navigation Component
- ViewBinding
- Material Design Components

### Flutter
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `go_router`: Routing
- `json_annotation` & `json_serializable`: JSON serialization

## Development

### Running Flutter Module Standalone
```bash
cd flutter_module
flutter run
```

### Generating JSON Serialization Code
```bash
cd flutter_module
flutter pub run build_runner build --delete-conflicting-outputs
```

### Adding New Features
1. For native features: Add to `app/src/main/java/com/kotlin/kotlinapp/`
2. For Flutter features: Add to `flutter_module/lib/features/`

## Communication Between Native and Flutter

### Native → Flutter
- Intent extras when launching FlutterActivity
- MethodChannel for runtime communication

### Flutter → Native
- MethodChannel: `com.kotlin.kotlinapp/flutter`
- Methods:
  - `pay`: Sends product data back to native

## Troubleshooting

### Flutter Module Not Found
If you see "Flutter module not found" in Gradle sync:
```bash
cd flutter_module
flutter pub get
```

### Build Errors
1. Clean the project: `Build > Clean Project`
2. Invalidate caches: `File > Invalidate Caches / Restart`
3. Rebuild: `Build > Rebuild Project`

### UUID Not Persisting
Check SharedPreferences:
```bash
adb shell run-as com.kotlin.kotlinapp cat shared_prefs/AppPrefs.xml
```

## License

[Add your license here]

## Contributors

[Add contributors here]
