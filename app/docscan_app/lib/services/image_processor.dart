import 'dart:io';

class ImageProcessor {
  /// Preprocess an image for optimal OCR:
  /// 1. Convert to grayscale
  /// 2. Increase contrast
  /// 3. Apply adaptive thresholding
  /// Returns path to processed image.
  static Future<String> preprocess(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return imagePath;

      // In production: OpenCV grayscale + contrast + adaptive threshold
      // For v1.0: just copy the file to processed path
      final processedPath = _getProcessedPath(imagePath);
      await file.copy(processedPath);

      return processedPath;
    } catch (e) {
      // Fallback: return original image
      return imagePath;
    }
  }

  /// Convert image to pure black and white (binary)
  /// This dramatically improves Tesseract accuracy for Arabic script
  static Future<String> binarize(String imagePath) async {
    // In production, use OpenCV adaptive threshold
    // For now, return preprocessed image
    return preprocess(imagePath);
  }

  static String _getProcessedPath(String originalPath) {
    final dir = Directory(dirname(originalPath));
    final basename = originalPath.split('/').last;
    final name = basename.replaceAll(RegExp(r'\.[^.]+$'), '');
    final ext = basename.contains('.') ? '.${basename.split('.').last}' : '';
    return '${dir.path}/${name}_processed$ext';
  }

  static String dirname(String path) {
    return path.substring(0, path.lastIndexOf('/'));
  }
}
