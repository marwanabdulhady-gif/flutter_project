# Muslim Leader App

A Flutter application for Muslim daily tracking with role-based UI.

## Features

- **Prayer Tracking** - Track all 7 daily prayers with sunnah and on-time status
- **Quran Tracking** - Record surah and juz progress
- **Knowledge Zone** - Track reading/learning with persistence
- **Fitness Activities** - Choose from running, walking, cycling, or gym
- **Daily Tasks** - Suggested tasks or custom tasks with carry-over
- **Self-Care** - Gaze lowering tracker with Quran verse
- **Family Ties** - Track who you connected with
- **Role-Based UI** - Different layouts for Adult Male, Adult Female, and Child
- **Bilingual** - Full English and Arabic support

## Running the App

### Web Version (Recommended)
```bash
flutter run -d edge
```

### Android APK
The APK is built automatically via GitHub Actions. After pushing to GitHub:
1. Go to your repository's "Actions" tab
2. Click on the latest workflow run
3. Download the APK from "Artifacts" section

Or build locally (requires Android Studio):
```bash
flutter build apk --release
```

## Development

```bash
# Get dependencies
flutter pub get

# Generate code (for Hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Project Structure

- `lib/models/` - Data models (DailyEntry, UserRole)
- `lib/providers/` - Riverpod state management
- `lib/factories/` - Role-specific UI builders
- `lib/screens/` - Main screens
- `lib/widgets/` - Reusable widgets
- `lib/l10n/` - Localization
- `lib/theme/` - App themes

## Technology Stack

- **Flutter** 3.27.0
- **State Management** - Riverpod
- **Local Storage** - Hive
- **Localization** - Custom implementation
- **Code Generation** - build_runner, hive_generator
