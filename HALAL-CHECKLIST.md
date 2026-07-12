# Halal-Compliance Checkliste

> **INTERN — nicht für öffentliche Marketing-Materialien.**
> Halal ist Bau-Standard, nicht Zielgruppe.
>
> In öffentlichen Materialien: "Built with privacy & quality first"

## Status: ✅ APPROVED (v1.0.0)

### Forbidden (10) — Darf NICHT vorkommen

| # | Element | Status | Nachweis |
|---|---------|--------|----------|
| 1 | **Riba** (Zinsen) | ✅ Nicht vorhanden | Keine Finanz-Features |
| 2 | **Gharar** (Unsicherheit) | ✅ Nicht vorhanden | Klare Preise (4.99€ Lifetime), keine Lotterie |
| 3 | **Maysir** (Glücksspiel) | ✅ Nicht vorhanden | Keine Glücksspiel-Mechaniken |
| 4 | **Haram Content** | ✅ Nicht vorhanden | Dokumentenscanner — keine Inhaltskategorie |
| 5 | **Instrumentalmusik** | ✅ Nicht vorhanden | Keine Sound-Features in v1.0 |
| 6 | **Irreführende Werbung** | ✅ Nicht vorhanden | Keine Werbung, keine Dark Patterns |
| 7 | **Datenausbeutung** | ✅ Nicht vorhanden | 100% offline, keine Datensammlung |
| 8 | **Zinsbasierte Finanzierung** | ✅ Nicht vorhanden | Lifetime-Kauf, kein BNPL |
| 9 | **Falscher Content** | ✅ Nicht vorhanden | OCR-Ergebnisse mit Confidence-Level |
| 10 | **Unanständige Bilder** | ✅ Nicht vorhanden | Nur Dokumenten-Scans |

### Required (8) — Muss vorhanden sein

| # | Element | Status | Implementierung |
|---|---------|--------|-----------------|
| 1 | **Erlaubte Soundtracks** | ✅ N/A in v1.0 | Keine Sounds | |
| 2 | **Preistransparenz** | ✅ Implementiert | 4.99€ Lifetime, kein Abo |
| 3 | **Privacy First** | ✅ Implementiert | 100% offline, kein Internet required |
| 4 | **Authentischer Content** | ✅ Implementiert | Realer OCR-Output, keine Halluzination |
| 5 | **Bescheidene Bilder** | ✅ Implementiert | Keine Personen, nur Dokumente |
| 6 | **Community-Moderation** | ✅ N/A | Kein soziales Feature |
| 7 | **Echte Abos** | ✅ Implementiert | Lifetime-Kauf (kein verstecktes Abo) |
| 8 | **Ehrliche Werbung** | ✅ N/A in v1.0 | Keine Werbung |

## Audit-Trail

| Release | Version | Datum | Status | Geprüft von |
|---------|---------|-------|--------|-------------|
| v1.0.0 | 1.0.0 | 2026-07-12 | ✅ APPROVED | Hermes Agent |

## Violation-Tracker

| # | Feature | Grund der Ablehnung | Alternativvorschlag |
|---|---------|-------------------|---------------------|
| 1 | Musik-Fokus-Töne | Instrumentalmusik (haram) | Naturgeräusche (Regen, Ozean, Wald) |
| 2 | Cloud-Backup | Datenverlassen Gerät (haram-adjacent) | Lokales Backup + verschlüsselter Export |
| 3 | Gamification-Badges mit Zufallsbelohnung | Gharar-ähnlich | Leistungsbasierte, deterministische Badges |

## Marketing-Übersetzung

| Intern | Öffentlich |
|--------|------------|
| Halal-zertifiziert | Privacy-first, ethisch gebaut |
| Keine Musik (haram) | Sound-free, minimal design |
| Kein Riba | Transparent pricing, no subscription tricks |
| Daten verlassen nicht das Gerät | 100% offline, your data stays yours |
| Keine Zins-Features | Simple one-time purchase |