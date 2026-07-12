# Security

## Prinzipien

DocScan Arab folgt **Privacy-by-Design** und **Security-by-Design**:

1. **Keine Daten verlassen das Gerät** — 100% offline Verarbeitung
2. **Kein Backend** — kein Angriffsvektor auf Serverseite
3. **Keine Tracking-SDKs** — keine Analytics, keine Werbe-SDKs
4. **Kein Account-Zwang** — keine User-Datenbank
5. **Minimale Berechtigungen** — nur Kamera + Speicher

## Berechtigungen

| Berechtigung | Grund | Optional? |
|-------------|-------|-----------|
| Kamera | Dokumente fotografieren | Ja (auch Galerie möglich) |
| Speicher | Dokumente lokal speichern | Ja (nur App-eigener Speicher) |
| Internet | **Wird nicht benötigt** | App funktioniert offline |

## Bedrohungsmodell

| Bedrohung | Risiko | Mitigation |
|-----------|--------|------------|
| Bilddaten abgefangen | Niedrig | Alles lokal, keine Übertragung |
| App liest fremde Fotos | Niedrig | Storage-Berechtigung nur für app-eigene Dateien |
| Tesseract-Binary kompromittiert | Sehr niedrig | Open Source, gepinnte Version |
| SharedPreferences manipuliert | Niedrig | Nur UI-Einstellungen (keine sensiblen Daten) |

## Abhängigkeiten

Alle Dependencies sind gepinnt in `pubspec.yaml`:
- `provider: ^6.1.5`
- `go_router: ^17.3.0`
- `tesseract_ocr: ^0.5.0`
- `flutter_edge_detection: ^1.2.0`

## Verantwortungsvolle Offenlegung

Sicherheitslücken bitte an: mail2mualimx@gmail.com