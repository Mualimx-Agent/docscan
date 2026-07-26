#!/usr/bin/env python3
"""
Generiert 8 Play-Store-Screenshots (1080x1920 PNG) für DocScan Arab.
Deep Teal Farb-Schema (seed: #006A6A), DE/EN/AR UI, Arabic OCR.

Farben:
  Primary:  #006A6A (Deep Teal)
  Secondary:#0D9488 (Teal)
  Surface:  #F0FDFA (Hell Mint)
  Accent:   #D97706 (Amber für Highlights)
"""

import os, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = Path("/home/ubuntu/apps/docscan/play_store/screenshots")
OUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Farbpalette ──────────────────────────────────────────────────
TEAL = "#006A6A"
TEAL_DARK = "#004D4D"
TEAL_LIGHT = "#99D6D6"
TEAL_SOFT = "#E8F5F5"
MINT = "#F0FDFA"
AMBER = "#D97706"
AMBER_LIGHT = "#FDE68A"
WHITE = "#FFFFFF"
TEXT = "#111827"
TEXT_SUB = "#6B7280"
RED = "#DC2626"
GREEN = "#059669"
SLATE = "#94A3B8"

W, H = 1080, 1920

# ── Fonts ────────────────────────────────────────────────────────
def find_font(size, bold=False):
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
        "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/TTF/DejaVuSans.ttf",
    ]
    for p in candidates:
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

def hex_to_rgba(h, a=255):
    h = h.lstrip("#")
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4)) + (a,)

def rounded_rect(draw, xy, r, fill, outline=None, width=1):
    draw.rounded_rectangle(xy, radius=r, fill=fill, outline=outline, width=width)

def draw_status_bar(draw, title="DocScan"):
    """Mock status bar + app bar."""
    draw.rectangle([0, 0, W, 60], fill=hex_to_rgba(TEAL))
    draw.text((40, 18), "9:41", font=find_font(20, bold=True), fill=hex_to_rgba(WHITE))
    draw.text((W-120, 18), "📶 🔋 94%", font=find_font(22, bold=False), fill=hex_to_rgba(WHITE))
    # App bar
    draw.rectangle([0, 60, W, 140], fill=hex_to_rgba(TEAL))
    f_title = find_font(36, bold=True)
    draw.text((40, 82), title, font=f_title, fill=hex_to_rgba(WHITE))

def draw_lang_tabs(draw, active=0, tabs=["DE", "EN", "AR"]):
    """Language selector tabs."""
    tab_w = 80
    start_x = W - len(tabs)*tab_w - 40
    for i, t in enumerate(tabs):
        tx = start_x + i * tab_w
        color = TEAL if i == active else SLATE
        f = find_font(24, bold=True) if i == active else find_font(24, bold=False)
        draw.text((tx+20, 88), t, font=f, fill=hex_to_rgba(color))

def draw_bottom_nav(draw, active_idx=0, labels=["Scan", "Docs", "Settings"]):
    y = H - 100
    draw.rectangle([0, y, W, H], fill=hex_to_rgba(WHITE))
    draw.line([(0, y), (W, y)], fill=hex_to_rgba("#E5E7EB"), width=2)
    icons = ["📷", "📄", "⚙️"]
    spacing = W // 3
    for i in range(3):
        cx = spacing * i + spacing // 2
        color = TEAL if i == active_idx else TEXT_SUB
        draw.text((cx-14, y+12), icons[i], font=find_font(28, bold=False), fill=hex_to_rgba(color))
        draw.text((cx-40, y+48), labels[i], font=find_font(24, bold=True if i == active_idx else False), fill=hex_to_rgba(color))

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 1: Home / Scan
# ═══════════════════════════════════════════════════════════════════
def make_01_home_scan():
    img = Image.new("RGB", (W, H), hex_to_rgba(MINT)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "DocScan")
    draw_lang_tabs(draw, 1)  # EN active
    draw_bottom_nav(draw, 0)

    # Hero section
    rounded_rect(draw, (40, 170, W-40, 310), 24, hex_to_rgba(TEAL))
    f_hero = find_font(48, bold=True)
    draw.text((70, 195), "📄 Scan & OCR", font=f_hero, fill=hex_to_rgba(WHITE))
    draw.text((70, 250), "Document scanning with Arabic OCR support", font=find_font(26, bold=False), fill=hex_to_rgba("#99D6D6"))

    # Quick actions
    rounded_rect(draw, (40, 340, W-40, 430), 20, hex_to_rgba(WHITE))
    draw.text((70, 360), "📷 Scan a document", font=find_font(30, bold=True), fill=hex_to_rgba(TEXT))
    draw.text((W-180, 360), "→", font=find_font(40, bold=True), fill=hex_to_rgba(TEAL))

    rounded_rect(draw, (40, 450, W-40, 540), 20, hex_to_rgba(WHITE))
    draw.text((70, 470), "📂 Import from gallery", font=find_font(30, bold=True), fill=hex_to_rgba(TEXT))
    draw.text((W-180, 470), "→", font=find_font(40, bold=True), fill=hex_to_rgba(TEAL))

    # Language hint
    rounded_rect(draw, (40, 570, W-40, 640), 16, hex_to_rgba(AMBER_LIGHT))
    draw.text((70, 588), "🌐 Supports: Deutsch · English · العربية", font=find_font(26, bold=True), fill=hex_to_rgba(AMBER))

    # Recent scans
    draw.text((40, 680), "Recent Scans", font=find_font(32, bold=True), fill=hex_to_rgba(TEXT))
    recent = [
        ("📄 Rechnung_03.pdf", "2 pages · today", TEAL),
        ("📄 Vertrag_2025.pdf", "8 pages · yesterday", TEAL),
        ("📄 Arabic_Doc.png", "Arabic RTL · 2 days ago", TEAL),
        ("📄 Notes_Science.pdf", "5 pages · 4 days ago", TEAL),
    ]
    for i, (name, desc, color) in enumerate(recent):
        ry = 730 + i * 90
        rounded_rect(draw, (40, ry, W-40, ry+75), 14, hex_to_rgba(WHITE))
        draw.text((70, ry+12), name, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((70, ry+44), desc, font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # FAB
    draw.ellipse([W-120, H-200, W-40, H-120], fill=hex_to_rgba(TEAL))
    draw.text((W-90, H-170), "📷", font=find_font(40, bold=False), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "01_home_scan.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 2: OCR Result
# ═══════════════════════════════════════════════════════════════════
def make_02_ocr_result():
    img = Image.new("RGB", (W, H), hex_to_rgba(WHITE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "OCR Result")
    draw_lang_tabs(draw, 1)
    draw_bottom_nav(draw, 0)

    # Result card
    rounded_rect(draw, (40, 170, W-40, 340), 20, hex_to_rgba(TEAL))
    draw.text((70, 195), "✅ OCR Complete", font=find_font(36, bold=True), fill=hex_to_rgba(WHITE))
    draw.text((70, 245), "Detected: English - Confidence 98.2%", font=find_font(26, bold=False), fill=hex_to_rgba("#99D6D6"))
    draw.text((70, 285), "⏱ 2.3s · 245 words · 1 page", font=find_font(24, bold=False), fill=hex_to_rgba("#CCE5E5"))

    # OCR text preview (editor-like)
    rounded_rect(draw, (40, 370, W-40, 1000), 20, hex_to_rgba("#FAFAFA"))
    draw.text((70, 395), "📝 Extracted Text (editable)", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    # Mock OCR text content
    sample_text = (
        "Machine Learning Fundamentals\n\n"
        "Machine learning is a subset of artificial intelligence (AI) that\n"
        "provides systems the ability to automatically learn and improve\n"
        "from experience without being explicitly programmed.\n\n"
        "Key Concepts:\n"
        "• Supervised Learning: Training with labeled data\n"
        "• Unsupervised Learning: Finding patterns in unlabeled data\n"
        "• Reinforcement Learning: Learning through trial and error\n\n"
        "Applications include image recognition, natural language\n"
        "processing, and predictive analytics."
    )
    f_text = find_font(24, bold=False)
    lines = sample_text.split("\n")
    for i, line in enumerate(lines):
        draw.text((70, 440+i*32), line, font=f_text, fill=hex_to_rgba(TEXT))

    # Action buttons
    rounded_rect(draw, (40, 1030, W//2-25, 1100), 16, hex_to_rgba(TEAL))
    draw.text((80, 1055), "📋 Copy Text", font=find_font(26, bold=True), fill=hex_to_rgba(WHITE))

    rounded_rect(draw, (W//2+25, 1030, W-40, 1100), 16, hex_to_rgba(TEAL_DARK))
    draw.text((W//2+60, 1055), "📤 Share", font=find_font(26, bold=True), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "02_ocr_result.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 3: PDF Export
# ═══════════════════════════════════════════════════════════════════
def make_03_pdf_export():
    img = Image.new("RGB", (W, H), hex_to_rgba(MINT)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Export as PDF")
    draw_lang_tabs(draw, 1)
    draw_bottom_nav(draw, 0)

    # Preview
    rounded_rect(draw, (40, 170, W-40, 700), 24, hex_to_rgba(WHITE))
    # PDF thumbnail area
    rounded_rect(draw, (100, 200, W-100, 520), 16, hex_to_rgba("#F9FAFB"))
    draw.text((W//2-80, 300), "📄", font=find_font(120, bold=False), fill=hex_to_rgba(TEAL))
    draw.text((W//2-120, 420), "Document_v2.pdf", font=find_font(30, bold=True), fill=hex_to_rgba(TEXT))

    # PDF info
    draw.text((70, 550), "📊 Export Info", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))
    info = [
        ("Pages:", "12"),
        ("Original size:", "18.4 MB"),
        ("PDF size:", "2.1 MB (88% reduction)"),
        ("OCR layers:", "Yes - searchable"),
        ("Language:", "English + Arabic"),
    ]
    for i, (label, val) in enumerate(info):
        draw.text((70, 595+i*40), f"{label} {val}", font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))

    # Settings
    rounded_rect(draw, (40, 800, W-40, 1050), 20, hex_to_rgba(WHITE))
    draw.text((70, 820), "⚙️ Export Settings", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    settings = [
        ("Page range:", "All pages", "1-12"),
        ("OCR layer:", "Enabled", "Searchable PDF"),
        ("Image quality:", "High", "300 DPI"),
        ("Language:", "Auto-detect", "EN + AR"),
        ("Page size:", "A4", "210 x 297 mm"),
    ]
    for i, (label, val, hint) in enumerate(settings):
        sy = 870 + i * 34
        draw.text((70, sy), label, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))
        draw.text((280, sy), val, font=find_font(24, bold=True), fill=hex_to_rgba(TEAL))
        draw.text((460, sy), f"({hint})", font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Export button
    rounded_rect(draw, (40, 1090, W-40, 1170), 24, hex_to_rgba(TEAL))
    draw.text((W//2-80, 1120), "📥 PDF Exportieren", font=find_font(32, bold=True), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "03_pdf_export.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 4: Document List
# ═══════════════════════════════════════════════════════════════════
def make_04_document_list():
    img = Image.new("RGB", (W, H), hex_to_rgba(WHITE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Documents")
    draw_lang_tabs(draw, 1)
    draw_bottom_nav(draw, 1)

    # Search bar
    rounded_rect(draw, (40, 170, W-40, 225), 16, hex_to_rgba("#F3F4F6"))
    draw.text((70, 188), "🔍 Search documents...", font=find_font(26, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Filter chips
    chips = ["All", "PDF", "Images", "Arabic", "Recent"]
    for i, c in enumerate(chips):
        cx = 40 + i * 130
        color = TEAL if i == 0 else "#F3F4F6"
        text_c = WHITE if i == 0 else TEXT
        rounded_rect(draw, (cx, 250, cx+120, 295), 16, fill=hex_to_rgba(color))
        draw.text((cx+20, 263), c, font=find_font(24, bold=True if i == 0 else False), fill=hex_to_rgba(text_c))

    # Document list
    docs = [
        ("📄 Rechnung_03.pdf", "2 pages · 12.4 KB · Today", TEAL),
        ("📄 Vertrag_2025.pdf", "8 pages · 245 KB · Yesterday", TEAL),
        ("📄 Arabic_Doc_Scan.png", "Arabic RTL · 3.2 MB · 2 days ago", TEAL_DARK),
        ("📄 Notes_Science.pdf", "5 pages · 89 KB · 4 days ago", TEAL),
        ("📄 Business_Card.png", "1 page · 1.1 MB · 1 week ago", TEAL),
        ("📄 كشف_حساب.pdf", "Arabic · 4 pages · 2 weeks ago", TEAL_DARK),
        ("📄 Meeting_Notes.pdf", "3 pages · 45 KB · 2 weeks ago", TEAL),
        ("📄 ID_Document.png", "1 page · 2.5 MB · 3 weeks ago", TEAL),
    ]
    for i, (name, desc, color) in enumerate(docs):
        dy = 320 + i * 86
        rounded_rect(draw, (40, dy, W-40, dy+76), 14, hex_to_rgba("#FAFAFA"))
        draw.text((70, dy+12), name, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((70, dy+44), desc, font=find_font(22, bold=False), fill=hex_to_rgba(TEXT_SUB))

    out = OUT_DIR / "04_document_list.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 5: RTL Text (Arabic)
# ═══════════════════════════════════════════════════════════════════
def reshape_arabic(text):
    """Reshape Arabic text using arabic_reshaper + bidi."""
    try:
        import arabic_reshaper
        from bidi.algorithm import get_display
        reshaped = arabic_reshaper.reshape(text)
        bidi_text = get_display(reshaped)
        return bidi_text
    except ImportError:
        return text

def make_05_rtl_text():
    img = Image.new("RGB", (W, H), hex_to_rgba(WHITE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Arabic OCR")
    draw_lang_tabs(draw, 0, ["DE", "EN", "AR"])  # AR active
    draw_bottom_nav(draw, 1)

    # Arabic header
    rounded_rect(draw, (40, 170, W-40, 250), 20, hex_to_rgba(TEAL_DARK))
    ar_title = reshape_arabic("النص المستخرج من المستند العربي")
    draw.text((W-70-400, 195), ar_title, font=find_font(32, bold=True), fill=hex_to_rgba(WHITE))
    ar_sub = reshape_arabic("تم التعرف على النص بنجاح - نسبة الدقة 96.5٪")
    draw.text((W-70-400, 235), ar_sub, font=find_font(24, bold=False), fill=hex_to_rgba("#99D6D6"))

    # Arabic text content (RTL display)
    rounded_rect(draw, (40, 280, W-40, 1000), 20, hex_to_rgba("#FAFAFA"))
    ar_label = reshape_arabic("المحتوى العربي (قابل للتعديل)")
    draw.text((W-70-200, 305), ar_label, font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    # Arabic text lines
    arabic_lines = [
        "بسم الله الرحمن الرحيم",
        "",
        "هذا المستند يحتوي على نص عربي تم استخراجه",
        "باستخدام تقنية التعرف الضوئي على الحروف (OCR).",
        "تدعم هذه التقنية النصوص العربية بجميع أشكالها",
        "الطباعية والمكتوبة بخط اليد.",
        "",
        "مزايا التطبيق:",
        "• التعرف على النصوص العربية المطبوعة",
        "• دعم الكتابة من اليمين إلى اليسار (RTL)",
        "• تصدير إلى PDF مع طبقة OCR قابلة للبحث",
        "• دعم متعدد اللغات: العربية، الإنجليزية، الألمانية",
        "",
        "تمت المعالجة بنجاح. عدد الكلمات: ٢٥٠ كلمة",
        "الوقت المستغرق: ٣.٥ ثوانٍ",
        "",
        "📎 كشف_حساب_بنكي.pdf",
    ]
    f_ar = find_font(26, bold=False)
    for i, line in enumerate(arabic_lines):
        if line.strip():
            reshaped = reshape_arabic(line)
            tw = draw.textlength(reshaped, font=f_ar) if hasattr(draw, 'textlength') else len(reshaped)*14
            # RTL: align right
            draw.text((W-70-tw, 360+i*34), reshaped, font=f_ar, fill=hex_to_rgba(TEXT))
        else:
            pass  # blank line

    # Language info badge
    rounded_rect(draw, (40, 1030, W-40, 1080), 14, hex_to_rgba(AMBER_LIGHT))
    ar_note = reshape_arabic("🌐 يدعم العربية والإنجليزية والألمانية - مع التعرف التلقائي على اللغة")
    draw.text((W-70-500, 1045), ar_note, font=find_font(22, bold=False), fill=hex_to_rgba(AMBER))

    out = OUT_DIR / "05_rtl_text.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 6: Settings
# ═══════════════════════════════════════════════════════════════════
def make_06_settings():
    img = Image.new("RGB", (W, H), hex_to_rgba(MINT)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Settings")
    draw_lang_tabs(draw, 1)
    draw_bottom_nav(draw, 2)

    groups = [
        ("📸 Scanning", [
            ("Image quality", "High (300 DPI)"),
            ("Auto-crop", "Enabled"),
            ("Enhance contrast", "Auto"),
            ("Color mode", "Color"),
        ]),
        ("🔤 OCR Settings", [
            ("Default language", "Auto-detect"),
            ("Arabic OCR", "Tesseract 5.x"),
            ("Confidence threshold", "70%"),
            ("Preprocessing", "Binarization + DPI"),
        ]),
        ("📄 Export", [
            ("Default format", "PDF"),
            ("OCR layer in PDF", "Enabled"),
            ("Compression", "High (88%)"),
            ("Page size", "A4"),
        ]),
        ("🔒 Privacy", [
            ("Local processing", "✅ All on-device"),
            ("Cloud sync", "Disabled"),
            ("Analytics", "Disabled"),
        ]),
    ]

    y = 170
    for group_name, items in groups:
        rounded_rect(draw, (40, y, W-40, y+40+len(items)*50), 16, hex_to_rgba(WHITE))
        draw.text((60, y+8), group_name, font=find_font(26, bold=True), fill=hex_to_rgba(TEXT))
        for i, (label, value) in enumerate(items):
            iy = y + 50 + i * 50
            draw.text((60, iy), label, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))
            draw.text((420, iy), value, font=find_font(24, bold=True), fill=hex_to_rgba(TEAL))
        y += 40 + len(items)*50 + 12

    out = OUT_DIR / "06_settings.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 7: Privacy
# ═══════════════════════════════════════════════════════════════════
def make_07_privacy():
    img = Image.new("RGB", (W, H), hex_to_rgba(WHITE)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Privacy & Security")
    draw_lang_tabs(draw, 1)
    draw_bottom_nav(draw, 2)

    # Shield icon
    draw.ellipse([W//2-60, 190, W//2+60, 310], fill=hex_to_rgba(TEAL))
    draw.text((W//2-25, 225), "🛡️", font=find_font(64, bold=False), fill=hex_to_rgba(WHITE))

    draw.text((W//2-180, 340), "Your data stays on your device", font=find_font(32, bold=True), fill=hex_to_rgba(TEXT))
    draw.text((W//2-250, 390), "100% on-device processing — no servers involved", font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Privacy features
    features = [
        ("offline", "🔒 Offline OCR", "All OCR runs locally via Tesseract. No internet needed."),
        ("local", "💾 Local Storage", "Scans stored only on your device. No cloud upload."),
        ("no_track", "🚫 No Tracking", "No analytics, no ads, no user profiling."),
        ("open", "📜 Open Source", "Full source code available for audit on GitHub."),
        ("gdpr", "✅ GDPR Compliant", "Designed for privacy by default."),
    ]
    for i, (key, label, desc) in enumerate(features):
        fy = 460 + i * 115
        rounded_rect(draw, (40, fy, W-40, fy+100), 18, hex_to_rgba(MINT))
        draw.text((70, fy+15), label, font=find_font(28, bold=True), fill=hex_to_rgba(TEAL))
        draw.text((70, fy+55), desc, font=find_font(22, bold=False), fill=hex_to_rgba(TEXT))

    # Certification note
    rounded_rect(draw, (40, 1060, W-40, 1130), 16, hex_to_rgba(TEAL))
    draw.text((70, 1085), "✅ Halal-compliant — ethical by design", font=find_font(26, bold=True), fill=hex_to_rgba(WHITE))

    out = OUT_DIR / "07_privacy.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  SCREENSHOT 8: Multi-Language
# ═══════════════════════════════════════════════════════════════════
def make_08_multi_language():
    img = Image.new("RGB", (W, H), hex_to_rgba(MINT)[:3])
    draw = ImageDraw.Draw(img)
    draw_status_bar(draw, "Multi-Language OCR")
    draw_lang_tabs(draw, 1, ["DE", "EN", "AR"])
    draw_bottom_nav(draw, 1)

    # Hero
    rounded_rect(draw, (40, 170, W-40, 280), 24, hex_to_rgba(TEAL))
    draw.text((70, 195), "🌍 Multi-Language Support", font=find_font(38, bold=True), fill=hex_to_rgba(WHITE))
    draw.text((70, 245), "Deutsch · English · العربية — all in one app", font=find_font(26, bold=False), fill=hex_to_rgba("#99D6D6"))

    # Language cards
    languages = [
        ("🇩🇪 Deutsch", "German OCR with Tesseract", "Fraktur, Handwriting, Printed", TEAL),
        ("🇬🇧 English", "Full Latin script support", "All fonts, sizes, qualities", TEAL_DARK),
        ("🇸🇦 العربية", "Arabic OCR (printed & handwritten)", "RTL support, Tashkeel, PDF", TEAL),
    ]
    for i, (name, desc1, desc2, color) in enumerate(languages):
        ly = 320 + i * 180
        rounded_rect(draw, (40, ly, W-40, ly+160), 20, hex_to_rgba(WHITE))
        draw.text((70, ly+20), name, font=find_font(36, bold=True), fill=hex_to_rgba(color))
        draw.text((70, ly+70), desc1, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT))
        draw.text((70, ly+105), desc2, font=find_font(24, bold=False), fill=hex_to_rgba(TEXT_SUB))

    # Feature highlights
    rounded_rect(draw, (40, 880, W-40, 1120), 20, hex_to_rgba(WHITE))
    draw.text((70, 900), "✨ Key Features", font=find_font(28, bold=True), fill=hex_to_rgba(TEXT))

    features = [
        "🔤 Auto language detection",
        "📑 Mixed-language document support",
        "🔄 RTL + LTR in same document",
        "🎯 High accuracy (98%+ for printed text)",
        "📥 Export with embedded OCR layer",
        "🔒 All processing stays on-device",
    ]
    for i, feat in enumerate(features):
        draw.text((70, 950+i*34), feat, font=find_font(26, bold=False), fill=hex_to_rgba(TEXT))

    out = OUT_DIR / "08_multi_language.png"
    img.save(out, "PNG", optimize=True)
    size = os.path.getsize(out)
    print(f"✅ {out.name}  ({size/1024:.0f} KB)")

# ═══════════════════════════════════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════════════════════════════════
def main():
    print("=" * 60)
    print("  DocScan — Play Store Screenshot Generator")
    print("=" * 60)
    make_01_home_scan()
    make_02_ocr_result()
    make_03_pdf_export()
    make_04_document_list()
    make_05_rtl_text()
    make_06_settings()
    make_07_privacy()
    make_08_multi_language()

    total = sum(
        os.path.getsize(OUT_DIR / f) for f in os.listdir(OUT_DIR)
        if f.endswith(".png")
    )
    print(f"\n🎉 8 Screenshots in {OUT_DIR}/")
    print(f"📦 Gesamt: {total/1024:.0f} KB")
    return 0

if __name__ == "__main__":
    sys.exit(main())