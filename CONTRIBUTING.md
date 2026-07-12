# Contributing

## Willkommen!

DocScan Arab ist ein Open-Source-Projekt (Apache 2.0). Beiträge sind willkommen — solange sie den Halal-Bau-Standard respektieren.

## Entwicklungsumgebung

```bash
# Setup
cd ~/apps/docscan/app/docscan_app
flutter pub get
flutter analyze

# Build
flutter build web --release
flutter build apk --release
```

## Coding Standards

- **State Management:** Provider (ChangeNotifier)
- **Routing:** GoRouter
- **Imports:** Relative imports innerhalb des Projekts
- **Models:** Immutable mit `copyWith`, `toJson`, `fromJson`
- **Screens:** StatelessWidget bevorzugen (Consumer für Provider)
- **Naming:** snake_case für Dateien, camelCase für Code

## Pull Request Prozess

1. Fork + Branch (z.B. `feature/arabic-handwriting`)
2. Implement + Test (`flutter analyze` muss 0 errors haben)
3. Dokumentation aktualisieren
4. Halal-Compliance prüfen (`HALAL-CHECKLIST.md`)
5. PR mit Beschreibung der Änderungen

## Halal-Compliance für Contributions

Jeder PR muss die Halal-Compliance bestätigen:

> **Halal-Check:**
> - [ ] Enthält keine haram Elemente (Riba, Gharar, Maysir, etc.)
> - [ ] Respektiert die 8 required elements (Privacy, Transparenz, etc.)
> - [ ] Keine Instrumentalmusik
> - [ ] Keine irreführenden UI-Muster
> - [ ] Funktioniert offline