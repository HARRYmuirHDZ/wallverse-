# WallVerse — Setup & Deployment Guide

## Table of Contents
1. [Firebase Setup](#firebase-setup)
2. [AdMob Integration](#admob-integration)
3. [Firestore Data Structure](#firestore-data-structure)
4. [Firebase Storage Structure](#firebase-storage-structure)
5. [Example Firestore Data](#example-firestore-data)
6. [APK Build Instructions](#apk-build-instructions)
7. [Language Support](#language-support)

---

## Firebase Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project** → Name it "WallVerse"
3. Enable Google Analytics (optional)

### 2. Add Android App
1. In Firebase Console → **Add App** → Android
2. Package name: `com.wallverse.wallverse`
3. Download `google-services.json`
4. Place it in `android/app/google-services.json`

### 3. Add iOS App (optional)
1. In Firebase Console → **Add App** → iOS
2. Bundle ID: `com.wallverse.wallverse`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/GoogleService-Info.plist`

### 4. Install FlutterFire CLI (recommended)
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=your-project-id
```

### 5. Enable Firebase in Code
In `lib/main.dart`, uncomment:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

In `lib/services/firebase_service.dart`, set:
```dart
static const bool _useFirebase = true;
```
And uncomment the Firestore query code in each method.

### 6. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to all collections
    match /categories/{document=**} {
      allow read: if true;
      allow write: if false;
    }
    match /subcategories/{document=**} {
      allow read: if true;
      allow write: if false;
    }
    match /wallpapers/{document=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

---

## AdMob Integration

### 1. Create AdMob Account
1. Go to [AdMob](https://admob.google.com/)
2. Create an account and add your app

### 2. Create Ad Units
Create these ad units in AdMob:
- **Banner Ad** — for category and grid screens
- **Interstitial Ad** — after downloads and navigation
- **Rewarded Ad** — for unlocking premium wallpapers

### 3. Update Ad Unit IDs
In `lib/services/admob_service.dart`, replace the test IDs:

```dart
static String get bannerAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXX/YYYYY'; // Your real banner ID
  }
  // ...
}

static String get interstitialAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXX/YYYYY'; // Your real interstitial ID
  }
  // ...
}

static String get rewardedAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXX/YYYYY'; // Your real rewarded ID
  }
  // ...
}
```

### 4. Android Configuration
In `android/app/src/main/AndroidManifest.xml`, add inside `<application>`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXX~YYYYY"/>
```

---

## Firestore Data Structure

### Collections

#### `categories`
| Field | Type   | Description          |
|-------|--------|----------------------|
| name  | string | Translation key name |
| icon  | string | Icon identifier      |

#### `subcategories`
| Field       | Type   | Description            |
|-------------|--------|------------------------|
| category_id | string | Parent category ID     |
| name        | string | Translation key name   |

#### `wallpapers`
| Field          | Type    | Description              |
|----------------|---------|--------------------------|
| subcategory_id | string  | Parent subcategory ID    |
| image_url      | string  | Firebase Storage URL     |
| resolution     | string  | "HD", "4K", or "8K"     |
| is_free        | boolean | True if free to download |

---

## Firebase Storage Structure

```
wallpapers/
├── anime/
│   ├── naruto/
│   │   ├── naruto_001.jpg
│   │   ├── naruto_002.jpg
│   │   └── ...
│   ├── dragon_ball/
│   └── ...
├── games/
│   ├── roblox/
│   └── ...
├── movies/
├── nature/
├── neon/
├── cars/
├── space/
└── minimalist/
```

---

## Example Firestore Data

### Import as JSON (use Firebase Admin SDK or manual entry)

#### Categories
```json
[
  { "id": "anime",      "name": "anime",      "icon": "anime" },
  { "id": "games",      "name": "games",      "icon": "games" },
  { "id": "movies",     "name": "movies",     "icon": "movies" },
  { "id": "nature",     "name": "nature",     "icon": "nature" },
  { "id": "neon",       "name": "neon",       "icon": "neon" },
  { "id": "cars",       "name": "cars",       "icon": "cars" },
  { "id": "space",      "name": "space",      "icon": "space" },
  { "id": "minimalist", "name": "minimalist", "icon": "minimalist" }
]
```

#### Subcategories (Anime example)
```json
[
  { "id": "naruto",          "category_id": "anime", "name": "naruto" },
  { "id": "dragon_ball",     "category_id": "anime", "name": "dragon_ball" },
  { "id": "demon_slayer",    "category_id": "anime", "name": "demon_slayer" },
  { "id": "one_piece",       "category_id": "anime", "name": "one_piece" },
  { "id": "attack_on_titan", "category_id": "anime", "name": "attack_on_titan" }
]
```

#### Wallpapers (Naruto example)
```json
[
  {
    "id": "naruto_wp_1",
    "subcategory_id": "naruto",
    "image_url": "https://firebasestorage.googleapis.com/...",
    "resolution": "4K",
    "is_free": true
  },
  {
    "id": "naruto_wp_2",
    "subcategory_id": "naruto",
    "image_url": "https://firebasestorage.googleapis.com/...",
    "resolution": "8K",
    "is_free": false
  }
]
```

---

## APK Build Instructions

### Debug APK
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK
```bash
# 1. Create a keystore (first time only)
keytool -genkey -v -keystore ~/wallverse-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wallverse

# 2. Create android/key.properties
echo "storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=wallverse
storeFile=PATH_TO_YOUR_JKS_FILE" > android/key.properties

# 3. Build release APK
flutter build apk --release

# 4. Or build App Bundle for Play Store
flutter build appbundle --release
```

Output:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Split APKs (smaller size per architecture)
```bash
flutter build apk --split-per-abi --release
```

---

## Language Support

The app supports **6 languages** out of the box:

| Code | Language   | Flag |
|------|------------|------|
| en   | English    | 🇺🇸  |
| es   | Español    | 🇪🇸  |
| fr   | Français   | 🇫🇷  |
| pt   | Português  | 🇧🇷  |
| de   | Deutsch    | 🇩🇪  |
| ja   | 日本語     | 🇯🇵  |

### Adding a New Language
1. Open `lib/l10n/app_localizations.dart`
2. Add a new `AppLocale` entry to `supportedLocales`
3. Add a new translation map in `_translations`
4. The language will automatically appear in the language selector

### How Language Selection Works
- Users select their language from the 🌐 button on the home screen
- The selection is persisted using `SharedPreferences`
- All UI strings update immediately when language changes
