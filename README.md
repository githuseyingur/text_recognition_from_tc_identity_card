# TC Identity Card Scanner — Flutter

A Flutter application that extracts data from Turkish ID cards using Google ML Kit OCR and automatic edge detection.

## Screenshots

<img width="280" height="580" alt="1" src="https://github.com/user-attachments/assets/35c74e92-0ea7-4116-af15-ff76df0c5ed7" />
<img width="280" height="580" alt="2" src="https://github.com/user-attachments/assets/9a45fc66-8ef1-4bac-93c9-1609a996bd56" />
<img width="280" height="580" alt="3" src="https://github.com/user-attachments/assets/63593e64-58cc-4679-8ee5-f47d223808aa" />
<img width="280" height="580" alt="4" src="https://github.com/user-attachments/assets/8f201d88-5d9d-4bb6-bb4c-0452f3753999" />
<img width="280" height="580" alt="5" src="https://github.com/user-attachments/assets/8982ffdf-8767-4e44-8a9b-45d6e430e3c5" />
<img width="280" height="580" alt="6" src="https://github.com/user-attachments/assets/25a37213-a4b7-457b-8ffa-c1d037019fde" />

---

## Features

- **Automatic edge detection** — Detects and crops the ID card boundary before processing
- **OCR text extraction** — Reads TC No, full name, birthdate, serial number, and validity date via Google ML Kit
- **Gallery import** — Pick an existing photo from the gallery as an alternative to the camera
- **Scan history** — Saves the last 50 scans locally; browse and clear past results
- **Clipboard copy** — Tap the copy icon next to TC No or full name to copy instantly
- **Share / Export** — Share all extracted fields as plain text with any app
- **TR / EN localization** — Toggle language from the app bar; all UI strings switch instantly
- **Dark mode** — Follows the system theme automatically
- **Camera guide overlay** — ID card–shaped frame (ISO 7810 ratio) with corner markers to help positioning

---

## Tech Stack

| Layer | Choice |
|---|---|
| State management | GetX |
| OCR | Google ML Kit Text Recognition |
| Edge detection | edge_detection_plus |
| History storage | shared_preferences |
| Share | share_plus |
| Gallery picker | image_picker |

---

## Architecture

```
lib/
├── bindings/       # GetX dependency injection (AppBinding)
├── controller/     # ExtractDataController — camera, OCR, parsing, history
├── core/           # AppSnackbar utility
├── l10n/           # TR / EN translations (GetX Translations)
├── models/         # IdCardModel, ScanRecord
├── services/       # HistoryService (SharedPreferences)
├── theme/          # AppTheme — light & dark (Material 3)
└── view/
    ├── scan_view.dart      # Camera / gallery capture
    ├── detail_view.dart    # Extracted data display + share + copy
    └── history_view.dart   # Past scans list
```

---

## How It Works

1. User taps **Scan ID Card** — edge detection opens and auto-crops the card
2. User taps **Extract Data** — ML Kit reads the text and parses each field by keyword matching
3. Results appear on the detail screen with copy and share options
4. Each successful scan is saved to local history automatically

---

## Setup Notes

### Android

Add to `AndroidManifest.xml` (required for gallery import):
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

### iOS

Add to `Info.plist` (required for gallery import):
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Required to select ID card photos from the gallery.</string>
```
