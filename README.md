# DocScan Arab 🧾

**Smart Document Scanner mit Arabisch-OCR & Tashkeel-Erkennung**

DocScan Arab ist ein datenschutzfreundlicher Dokumentenscanner für den arabischen Markt. Speziell optimiert für arabische Texte (gedruckt & handschriftlich) mit RTL-Unterstützung. 100% offline — keine Daten verlassen Ihr Gerät.

## Features

| Feature | Status |
|---------|--------|
| 📷 Kamera-Integration mit Edge-Detection | ✅ v1.0 |
| ✂️ Auto-Crop & Perspektivkorrektur | ✅ v1.0 |
| 🔤 Arabic OCR (gedruckt) | ✅ v1.0 |
| 📝 RTL-Textausgabe | ✅ v1.0 |
| 📋 Text kopieren/teilen/exportieren | ✅ v1.0 |
| 💾 Offline-Dokumentenspeicher | ✅ v1.0 |
| 📄 PDF-Export | ✅ v1.0 |
| 🌐 DE/EN/AR UI | ✅ v1.0 |
| 🖋️ Handschrift-Erkennung | 🚧 v1.1 |
| 🔤 Tashkeel-Erhaltung | 🚧 v1.1 |
| 🌍 Übersetzung Arabisch↔Englisch | 🚧 v1.1 |
| 📑 Behörden-Formular-Autofill | 🚧 v1.2 |

## Schnellstart

```bash
# Flutter Web-Demo starten
cd app/docscan_app
flutter build web --release
cd build/web && python3 -m http.server 8093
```

## Stack

- **Frontend:** Flutter 3.44 (Android + Web + iOS)
- **OCR Engine:** Tesseract 5.x + ara.traineddata
- **Edge Detection:** flutter_edge_detection
- **State:** Provider
- **Speicher:** SharedPreferences + lokales Dateisystem

## Lizenz

Apache 2.0 — see [LICENSE](LICENSE)

## Verwandte Apps

- [FocusFlow](https://github.com/Mualimx/focusflow) — Pomodoro + Tasks
- [StillMind](https://github.com/Mualimx/stillmind) — Meditation
- [Tidy](https://github.com/Mualimx/tidy) — File Cleaner
- [Recall](https://github.com/Mualimx/recall) — Flashcards