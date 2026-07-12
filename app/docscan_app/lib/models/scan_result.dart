import 'dart:ui' show Rect;
import 'package:flutter/foundation.dart';

@immutable
class ScanResult {
  final String rawText;
  final List<TextLine> lines;
  final double averageConfidence;
  final bool hasTashkeel;

  const ScanResult({
    this.rawText = '',
    this.lines = const [],
    this.averageConfidence = 0.0,
    this.hasTashkeel = false,
  });

  Map<String, dynamic> toJson() => {
        'rawText': rawText,
        'lines': lines.map((l) => l.toJson()).toList(),
        'averageConfidence': averageConfidence,
        'hasTashkeel': hasTashkeel,
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      rawText: json['rawText'] as String? ?? '',
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => TextLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      averageConfidence: (json['averageConfidence'] as num?)?.toDouble() ?? 0.0,
      hasTashkeel: json['hasTashkeel'] as bool? ?? false,
    );
  }
}

@immutable
class TextLine {
  final String text;
  final double confidence;
  final Rect? boundingBox;

  const TextLine({
    required this.text,
    this.confidence = 0.0,
    this.boundingBox,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'confidence': confidence,
        'boundingBox': boundingBox != null
            ? {
                'left': boundingBox!.left,
                'top': boundingBox!.top,
                'width': boundingBox!.width,
                'height': boundingBox!.height,
              }
            : null,
      };

  factory TextLine.fromJson(Map<String, dynamic> json) {
    return TextLine(
      text: json['text'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      boundingBox: json['boundingBox'] != null
          ? Rect.fromLTWH(
              (json['boundingBox']['left'] as num).toDouble(),
              (json['boundingBox']['top'] as num).toDouble(),
              (json['boundingBox']['width'] as num).toDouble(),
              (json['boundingBox']['height'] as num).toDouble(),
            )
          : null,
    );
  }
}