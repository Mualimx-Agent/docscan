import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ExportService {
  /// Export OCR text as a plain text file and share
  static Future<void> shareText(String text, String filename) async {
    final tempDir = Directory.systemTemp;
    final file = File('${tempDir.path}/$filename.txt');
    await file.writeAsString(text);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'OCR Result',
      ),
    );
  }

  /// Export as PDF with OCR text layer
  /// For v1.0: simple text export
  /// v1.1+: full PDF with embedded text
  static Future<String> createPdf(String imagePath, String ocrText) async {
    final docDir = Directory('${Platform.environment['HOME'] ?? '/tmp'}/docscan/exports');
    if (!await docDir.exists()) {
      await docDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final pdfPath = '${docDir.path}/scan_$timestamp.pdf';

    // For v1.0: create a basic text-based "PDF"
    // In production: use pdf package (flutter pub add pdf)
    final pdfContent = '''
%PDF-1.4
1 0 obj
<< /Type /Catalog /Pages 2 0 R >>
endobj
2 0 obj
<< /Type /Pages /Kids [3 0 R] /Count 1 >>
endobj
3 0 obj
<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>
endobj
4 0 obj
<< /Length 44 >>
stream
BT /F1 12 Tf 72 720 Td ($ocrText) Tj ET
endstream
endobj
5 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>
endobj
xref
0 6
...
trailer
<< /Size 6 /Root 1 0 R >>
startxref
...
%%EOF
''';

    await File(pdfPath).writeAsString(pdfContent);
    return pdfPath;
  }

  /// Save OCR result and image reference locally
  static Future<String> saveDocument({
    required String imagePath,
    required String ocrText,
    required String language,
  }) async {
    final docDir = Directory('${Platform.environment['HOME'] ?? '/tmp'}/docscan/documents');
    if (!await docDir.exists()) {
      await docDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final docPath = '${docDir.path}/doc_$timestamp.json';

    final json = '''
{
  "imagePath": "$imagePath",
  "ocrText": ${_escapeJson(ocrText)},
  "language": "$language",
  "createdAt": "${DateTime.now().toIso8601String()}"
}
''';

    await File(docPath).writeAsString(json);
    return docPath;
  }

  static String _escapeJson(String text) {
    return '"${text.replaceAll('"', '\\"').replaceAll('\n', '\\n').replaceAll('\r', '\\r')}"';
  }
}
