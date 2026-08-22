# Diese Bilder duerfen NICHT in den Play Store

Sie wurden von `generate_screenshots.py` mit Pillow **gezeichnet** und stammen
nicht aus der laufenden App.

**Beweis:** die zugehoerigen Rohbilder in `raw_screenshots/` sind alle
byte-identisch (dieselbe MD5). Es wurde nie ein Screenshot der App gemacht --
das Skript hat auf eine einzige Platzhalter-Datei sechsmal verschiedenen Text
gemalt.

Weitere Merkmale: erfundene Angaben (DocScan zeigt "Confidence 98.2 %"), die
iPhone-Statusleiste "9:41", und leere Kaestchen statt Emoji, weil der Schrift
die Glyphen fehlen.

Google lehnt Store-Eintraege mit Screenshots ab, die nicht aus der App stammen;
im schlimmsten Fall trifft die Massnahme das ganze Entwicklerkonto.

**Ersatz:** So wie bei Tawali -- Web-Build der App bauen und per Chrome
DevTools Protocol aufnehmen. Anleitung:
`~/apps/twally/play_store/screenshots/HERKUNFT.md`

Verschoben am 22.08.2026, 8 Dateien. Aufheben nur zur Beweissicherung.
