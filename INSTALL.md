# Installation

## Voraussetzungen

- **Flutter 3.44+** (`~/flutter/bin/flutter`)
- **Dart 3.12+**
- **Git**
- **ImageMagick** (optional, für Icons)

## Android Build

```bash
# Flutter in PATH
export PATH="$HOME/flutter/bin:$PATH"

# Ins Projektverzeichnis
cd ~/apps/docscan/app/docscan_app

# Dependencies installieren
flutter pub get

# Android APK bauen
flutter build apk --release

# Android AAB (für Play Store)
flutter build appbundle --release
```

## Web Build

```bash
# Web-Demo bauen
cd ~/apps/docscan/app/docscan_app
flutter build web --release

# Lokal servieren (z.B. Port 8093)
cd build/web && python3 -m http.server 8093
```

## iOS Build

> **Hinweis:** iOS Build erfordert Xcode auf macOS

```bash
cd ~/apps/docscan/app/docscan_app
flutter build ios --release
```

## Tesseract Traineddata

Die Arabic-Traineddata (`ara.traineddata`) wird automatisch aus dem GitHub-Repository geladen:

```bash
mkdir -p android/app/src/main/assets/tessdata/
wget https://github.com/tesseract-ocr/tessdata/raw/main/ara.traineddata \
  -O android/app/src/main/assets/tessdata/ara.traineddata
```

## Port-Konvention

| App | Port |
|-----|------|
| FocusFlow | 8081 |
| DocScan Arab | **8093** (vorgeschlagen) |

## Umgebungsvariablen

Keine erforderlich — die App läuft 100% offline ohne Backend.