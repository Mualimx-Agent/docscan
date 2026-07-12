import 'package:flutter/foundation.dart';
import '../models/scan_result.dart';
import '../services/ocr_service.dart';
import '../services/image_processor.dart';

class ScanProvider extends ChangeNotifier {
  ScanState _state = ScanState.idle;
  String? _error;
  ScanResult? _lastResult;
  double _progress = 0.0;

  ScanState get state => _state;
  String? get error => _error;
  ScanResult? get lastResult => _lastResult;
  double get progress => _progress;
  bool get isScanning => _state == ScanState.processing;

  Future<ScanResult?> scanImage(String imagePath) async {
    _state = ScanState.processing;
    _error = null;
    _progress = 0.1;
    notifyListeners();

    try {
      // Step 1: Preprocess image
      _progress = 0.3;
      notifyListeners();
      final processedPath = await ImageProcessor.preprocess(imagePath);

      // Step 2: Binarize for better OCR
      _progress = 0.5;
      notifyListeners();
      final binaryPath = await ImageProcessor.binarize(processedPath);

      // Step 3: Run OCR
      _progress = 0.7;
      notifyListeners();
      final result = await OcrService.extractText(binaryPath);

      if (!result.isSuccess) {
        _error = result.error ?? 'OCR failed';
        _state = ScanState.error;
        notifyListeners();
        return null;
      }

      // Step 4: Post-process text
      final cleanedText = OcrService.postProcess(result.text);
      final hasTashkeel = OcrService.hasTashkeel(cleanedText);

      // Build lines from text
      final lines = cleanedText
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .map((l) => TextLine(text: l.trim()))
          .toList();

      _lastResult = ScanResult(
        rawText: cleanedText,
        lines: lines,
        averageConfidence: result.confidence,
        hasTashkeel: hasTashkeel,
      );

      _progress = 1.0;
      _state = ScanState.completed;
      notifyListeners();
      return _lastResult;
    } catch (e) {
      _error = e.toString();
      _state = ScanState.error;
      _progress = 0.0;
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _state = ScanState.idle;
    _error = null;
    _lastResult = null;
    _progress = 0.0;
    notifyListeners();
  }
}

enum ScanState { idle, processing, completed, error }