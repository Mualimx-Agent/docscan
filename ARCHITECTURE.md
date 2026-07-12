# Architektur

## Übersicht

DocScan Arab ist eine **Privacy-First-Dokumentenscanner-App** mit lokalem Tesseract-OCR. 100% offline — kein Backend, keine Cloud, keine Datensammlung.

## Architektur-Diagramm

```
┌─────────────────────────────────────────────────────────────┐
│                      DocScan Arab App                        │
├─────────────────────────────────────────────────────────────┤
│                       Flutter UI Layer                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │Onboarding│ │  Home    │ │  Scan    │ │ Result   │       │
│  │ Screen   │ │  Screen  │ │  Screen  │ │ Screen   │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
├─────────────────────────────────────────────────────────────┤
│                      Provider Layer                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                    │
│  │  Scan    │ │Document  │ │Settings  │                    │
│  │ Provider │ │ Provider │ │ Provider │                    │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘                    │
├───────┼─────────────┼───────────┼──────────────────────────┤
│  ┌────▼─────────────▼───────────▼────┐                     │
│  │         Services Layer            │                     │
│  │  ┌──────────┐  ┌─────────────┐   │                     │
│  │  │   OCR    │  │    Image    │   │                     │
│  │  │ Service  │  │  Processor  │   │                     │
│  │  └────┬─────┘  └──────┬──────┘   │                     │
│  │  ┌────▼───────────────▼──────┐   │                     │
│  │  │     Export Service        │   │                     │
│  │  └──────────┬───────────────┘   │                     │
│  └─────────────┼───────────────────┘                     │
├────────────────┼────────────────────────────────────────┤
│   Native Layer │                                        │
│  ┌─────────────▼──────────────────────────┐              │
│  │   Tesseract 5.x (C++ NDK)              │              │
│  │   + ara.traineddata                    │              │
│  └────────────────────────────────────────┘              │
│  ┌────────────────────────────────────────┐              │
│  │   Camera / Edge Detection (Android)     │              │
│  └────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────┘
```

## Datenfluss

```
Kamera/Image Picker
    ↓
Edge Detection + Perspective Crop
    ↓
Bildvorverarbeitung (Grayscale → Contrast → Binary)
    ↓
Tesseract OCR (ara.traineddata)
    ↓
RTL-Postprocessing (Tashkeel-Erhaltung, Zeilenordnung)
    ↓
Ausgabe: HTML/Text/PDF
```

## Verzeichnisstruktur

```
lib/
├── main.dart                  # App-Einstieg + MultiProvider
├── theme/
│   └── app_theme.dart         # Material 3 (Light+Dark, GoogleFonts Cairo/Inter)
├── models/
│   ├── document.dart          # ScannedDocument (immutable)
│   └── scan_result.dart       # ScanResult + TextLine
├── services/
│   ├── ocr_service.dart       # Tesseract Wrapper + Arabisch-Postprocessing
│   ├── image_processor.dart   # Bildvorverarbeitung (Grayscale, Binarize)
│   └── export_service.dart    # PDF, Text, Share
├── providers/
│   ├── scan_provider.dart     # Scan-Status + OCR-Pipeline
│   ├── document_provider.dart # Dokumentensammlung
│   └── settings_provider.dart # Sprache, Theme
├── router/
│   └── app_router.dart        # GoRouter (6 Routen)
├── screens/
│   ├── onboarding_screen.dart # 3-Seiten Intro (DE/AR/EN)
│   ├── home_screen.dart       # Dokumentenliste + Scan-Button
│   ├── scan_screen.dart       # Kamera/Galerie-Auswahl
│   ├── result_screen.dart     # OCR-Ergebnis + Export
│   ├── settings_screen.dart   # Sprache, Dark Mode, About
│   └── about_screen.dart      # App-Info + Halal-Standards
└── widgets/
    ├── document_card.dart     # Dokument-Vorschau-Karte
    ├── scan_preview.dart      # Bildvorschau
    └── ocr_result_view.dart   # RTL-Textansicht
```

## Wichtige Entscheidungen

| Entscheidung | Warum |
|-------------|-------|
| **Kein Backend** | Privacy-first, keine Serverkosten, sofort auslieferbar |
| **Tesseract statt ML Kit** | ML Kit unterstützt Arabisch nicht offline |
| **Provider statt Bloc** | Bewährt aus vorherigen Apps, einfacher für v1.0 |
| **GoogleFonts Cairo** | Cairo hat exzellente Arabisch-Unterstützung |
| **UUID für Dokument-IDs** | Eindeutige IDs ohne Backend |