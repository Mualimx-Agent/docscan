# Deployment

## Build-Artefakte

| Plattform | Befehl | Artefakt |
|-----------|--------|----------|
| Web | `flutter build web --release` | `build/web/` |
| Android APK | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| iOS | `flutter build ios --release` | `build/ios/` (Xcode erforderlich) |

## Play Store Deployment

> **Hinweis:** Play Store $25 Entwicklerkonto ist die einzige bezahlte Dienstleistung.
> Alle anderen Tools sind kostenlos/Open Source.

### Vorbereitung

1. **Versionierung:** `pubspec.yaml` → `version: 1.0.0+1`
2. **Signing Key:** `~/.keystores/docscan-upload.jks`
3. **Keystore-Konfiguration:** `android/key.properties`
4. **App-Icons:** 5 Densities (48—192px) + 512x512 Master
5. **Feature Graphic:** 1024x500 (Play Store Listing)

### Play Store Listing

| Feld | Wert |
|------|------|
| Title | DocScan Arab |
| Short Description (EN) | Smart Arabic Document Scanner — offline OCR |
| Short Description (AR) | ماسح مستندات ذكي — التعرف على النص العربي دون إنترنت |
| Category | Productivity |
| Tags | scanner, arabic ocr, document scanner |
| Content Rating | Everyone |

## CI/CD (GitHub Actions)

Geplant für v1.1. Workflow:

```yaml
name: Build & Release
on:
  push:
    tags: ['v*']
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release
      - uses: actions/upload-artifact@v4
        with:
          name: web-build
          path: build/web
```

## Port-Allokation

| App | Port | Status |
|-----|------|--------|
| FocusFlow | 8081 | ✅ Aktiv |
| DocScan Arab | 8093 | 🆕 Vorgeschlagen |

## Server-Demo

```bash
cd ~/apps/docscan/app/docscan_app/build/web
python3 -m http.server 8093
```

Öffne: `http://<server-ip>:8093` (bei Oracle Cloud: SSH-Tunnel nötig)