import 'dart:io';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:tesseract_ocr/ocr_engine_config.dart';

class OcrService {
  /// Extract Arabic text from an image using Tesseract OCR.
  /// Returns the recognized text and confidence level.
  static Future<OcrResult> extractText(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return OcrResult(text: '', confidence: 0.0, error: 'Image file not found');
      }

      final text = await TesseractOcr.extractText(
        imagePath,
        config: OCRConfig(
          language: 'ara',
          options: {TesseractConfig.pageSegMode: '3'},
        ),
      );

      if (text.isEmpty) {
        return OcrResult(text: '', confidence: 0.0, error: 'No text detected');
      }

      // Tesseract doesn't output confidence per document directly.
      // We estimate based on whether we got meaningful Arabic text.
      final hasArabicChars = _containsArabic(text);
      final confidence = hasArabicChars ? 0.75 : 0.3;

      return OcrResult(
        text: text,
        confidence: confidence,
        hasArabic: hasArabicChars,
      );
    } catch (e) {
      return OcrResult(text: '', confidence: 0.0, error: e.toString());
    }
  }

  /// Check if at least 20% of characters are Arabic Unicode
  static bool _containsArabic(String text) {
    if (text.isEmpty) return false;
    int arabicCount = 0;
    for (final rune in text.runes) {
      // Arabic block: 0x0600 - 0x06FF, Arabic Supplement: 0x0750-0x077F
      if ((rune >= 0x0600 && rune <= 0x06FF) ||
          (rune >= 0x0750 && rune <= 0x077F) ||
          (rune >= 0xFE70 && rune <= 0xFEFF) || // Arabic Presentation Forms-B
          (rune >= 0xFB50 && rune <= 0xFDFF) || // Arabic Presentation Forms-A
          (rune >= 0x08A0 && rune <= 0x08FF)) {
        // Arabic Extended-A
        arabicCount++;
      }
    }
    return (arabicCount / text.length) > 0.2;
  }

  /// Check if text contains Tashkeel (Arabic diacritics)
  static bool hasTashkeel(String text) {
    for (final rune in text.runes) {
      // Tashkeel marks: Fathah (064E), Dammah (064F), Kasrah (0650),
      // Shaddah (0651), Sukun (0652), etc.
      if ((rune >= 0x064B && rune <= 0x0652) ||
          (rune >= 0x0670 && rune <= 0x0670) ||
          rune == 0x06D6 || rune == 0x06D7 || rune == 0x06D8 ||
          rune == 0x06D9 || rune == 0x06DA || rune == 0x06DB ||
          rune == 0x06DC || rune == 0x06DF || rune == 0x06E0 ||
          rune == 0x06E1 || rune == 0x06E2 || rune == 0x06E3 ||
          rune == 0x06E4 || rune == 0x06E5 || rune == 0x06E6 ||
          rune == 0x06E7 || rune == 0x06E8 || rune == 0x06EA) {
        return true;
      }
    }
    return false;
  }

  /// Post-process OCR output: correct common Arabic OCR errors
  static String postProcess(String text) {
    // Remove excessive whitespace
    String result = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Common Tesseract Arabic substitutions
    const substitutions = {
      'لاآ': 'لا',
      'لاأ': 'لأ',
      'لاإ': 'لإ',
      'ه ': 'ة ',
      'ه.': 'ة.',
      'ه,': 'ة,',
    };

    substitutions.forEach((key, value) {
      result = result.replaceAll(key, value);
    });

    return result;
  }
}

class OcrResult {
  final String text;
  final double confidence;
  final String? error;
  final bool hasArabic;

  const OcrResult({
    required this.text,
    required this.confidence,
    this.error,
    this.hasArabic = false,
  });

  bool get isSuccess => error == null && text.isNotEmpty;
}
