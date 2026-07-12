import 'package:flutter/foundation.dart';

@immutable
class ScannedDocument {
  final String id;
  final String imagePath;
  final String ocrText;
  final double confidence;
  final String language;
  final DateTime createdAt;

  const ScannedDocument({
    required this.id,
    required this.imagePath,
    this.ocrText = '',
    this.confidence = 0.0,
    this.language = 'ara',
    required this.createdAt,
  });

  ScannedDocument copyWith({
    String? id,
    String? imagePath,
    String? ocrText,
    double? confidence,
    String? language,
    DateTime? createdAt,
  }) {
    return ScannedDocument(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      ocrText: ocrText ?? this.ocrText,
      confidence: confidence ?? this.confidence,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'ocrText': ocrText,
        'confidence': confidence,
        'language': language,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ScannedDocument.fromJson(Map<String, dynamic> json) {
    return ScannedDocument(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      ocrText: json['ocrText'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      language: json['language'] as String? ?? 'ara',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}