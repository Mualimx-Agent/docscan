# Play Console Schritt-für-Schritt: DocScan v1.0.0 einreichen

> **Anleitung:** Folge diesen Schritten in Google Play Console.
> **Geschätzter Aufwand:** 30-45 Minuten.
> **Ziel:** App im Internal Testing Track (kein Review bei Internal Testing)

---

## Voraussetzungen

- [x] Google Play Developer Account (€25 einmalig, bereits bezahlt)
- [x] Developer-Profil vollständig
- [x] Identitätsverifikation abgeschlossen
- [ ] AAB-File (App-Bundle) — wird via GitHub Actions gebaut
- [x] Store-Listing-Texte (DE+EN+AR) → `play_store/listing_v1.0.md`
- [x] App-Icon 512x512 → `play_store/app_icon_512.png`
- [x] Feature Graphic 1024x500 → `play_store/feature_graphic.png`
- [x] 8+ Phone-Screenshots 1080x1920 → `play_store/screenshots/`
- [x] Data Safety Form → `play_store/data_safety_v1.0.md`
- [x] Privacy Policy → `play_store/privacy_policy.html`

---

## Schritt 1: App erstellen

1. https://play.google.com/console → "App erstellen"
2. **Name:** DocScan – Document Scanner
3. **Standardsprache:** Deutsch (Deutschland)
4. **App-Typ:** App
5. **Kostenlos:** Ja
6. **Entwicklererklärung:** "Ich erkläre hiermit, dass ..."
7. **Auf "App erstellen" klicken**

---

## Schritt 2: Dashboard-Aufgaben (Reihenfolge)

### 2.1 App-Details
- **App-Name:** DocScan – Document Scanner
- **Kurzbeschreibung:** Dokumente scannen, Text extrahieren & PDF exportieren. 100% offline.
- **Vollständige Beschreibung:** Aus `play_store/listing_v1.0.md` → Full Description (DE) kopieren
- **Kategorie:** Produktivität
- **Tags:** "Dokumentenscanner", "OCR", "Texterkennung", "PDF Export"

### 2.2 App-Inhalt → Datenschutz
- **Datenschutzerklärung:** URL zur gehosteten Privacy Policy
- **E-Mail:** mail2mualimx@gmail.com

### 2.3 App-Inhalt → Datensicherheit
- **"Erhebt Ihre App personenbezogene Daten?"** → NEIN
- **Alle 14 Kategorien bleiben auf "Nicht erhoben"**
- **Freitext:** Aus `play_store/data_safety_v1.0.md` kopieren

### 2.4 Anzeigen
- **Enthält Ihre App Werbung?** → NEIN

### 2.5 Monetarisierung → In-App-Produkte
- **Produkt erstellen:** "DocScan Premium"
- **Produkt-ID:** `premium`
- **Typ:** Einmaliger Kauf (non-consumable)
- **Preis:** 4,99 €
- **Beschreibung:** "Einmaliger Kauf. Lebenslange Updates."

### 2.6 Inhaltsklassifizierung (IARC)
- Alle 5 Fragen mit NEIN beantworten:
  - Violence → No
  - Sexual content → No
  - Language (profanity) → No
  - Controlled substances → No
  - User-generated content shared → No
- **Ergebnis:** PEGI 3 / USK 0 / ESRB E

### 2.7 Zielgruppe
- **Altersgruppe:** Alle Altersgruppen
- **Designed for Families:** Nein (nicht im Programm)

### 2.8 App-Version hochladen (AAB)
1. **AAB herunterladen:** Von GitHub Actions → Artifacts → `app-release-aab`
2. **Oder selbst bauen** (auf x86_64-Maschine):
   ```bash
   cd ~/apps/docscan/app/docscan_app
   flutter build appbundle --release
   ```
3. **AAB hochladen** in Play Console
4. **Release-Name:** "v1.0.0"
5. **Release-Notes (DE):**
   ```
   • Dokumente scannen mit automatischer Kantenerkennung
   • Arabische und westliche Texterkennung (OCR)
   • PDF-Export mit extrahiertem Text
   • 100% offline, keine Datenerhebung
   • Mehrsprachig: Deutsch, Englisch, العربية
   ```

### 2.9 Übersetzungen → Übersetzungen verwalten
- **Englisch (Vereinigte Staaten):** Alle Texte aus `listing_v1.0.md` (EN) kopieren
- **Arabisch (Saudi-Arabien):** Alle Texte aus `listing_v1.0.md` (AR) kopieren

---

## Schritt 3: Test und Review

### Internal Testing (direkt, kein Review)
1. "Internal Testing" auswählen
2. 5-10 Tester per E-Mail hinzufügen (dich selbst)
3. App installieren und testen
4. Kein Google-Review nötig → sofort live

### Closed Testing (optional, 1-2 Wochen Review)
1. "Closed Testing" auswählen
2. 20+ Tester über 14 Tage
3. Danach: Promotion zu Production

### Production (Google Review, 3-7 Tage)
1. "Production" auswählen
2. **10% Rollout** (nicht 100%!)
3. Nach 1 Woche: 100% Rollout

---

## Häufige Probleme

| Problem | Lösung |
|---|---|
| "Privacy Policy URL nicht erreichbar" | Host auf GitHub Pages; URL muss öffentlich HTTPS sein |
| "AAB rejected: min SDK too low" | minSdk = 23 in build.gradle |
| "Data Safety: Widerspruch mit Code" | App ist 100% offline → keine Internetcalls → alles "No" |
| "Titel zu lang" | 30 Zeichen Limit → Kurzform verwenden |
| "IARC: 7+ wegen User Content" | Lokale Dokumente sind kein User-Sharing → "No" |
| "IAP nicht aktiv" | IAP muss "Active" sein, nicht "Draft" |