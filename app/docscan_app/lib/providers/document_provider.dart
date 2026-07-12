import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/document.dart';
import 'dart:convert';
import 'dart:io';

class DocumentProvider extends ChangeNotifier {
  List<ScannedDocument> _documents = [];
  bool _isLoading = false;

  List<ScannedDocument> get documents => List.unmodifiable(_documents);
  bool get isLoading => _isLoading;
  int get count => _documents.length;

  DocumentProvider() {
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final docDir = Directory('${Platform.environment['HOME'] ?? '/tmp'}/docscan/documents');
      if (await docDir.exists()) {
        final files = await docDir.list().where((entity) => entity.path.endsWith('.json')).toList();
        files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

        _documents = [];
        for (final file in files) {
          try {
            final content = await File(file.path).readAsString();
            final json = jsonDecode(content) as Map<String, dynamic>;
            _documents.add(ScannedDocument.fromJson(json));
          } catch (_) {}
        }
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<ScannedDocument> addDocument({
    required String imagePath,
    required String ocrText,
    required double confidence,
    String language = 'ara',
  }) async {
    final doc = ScannedDocument(
      id: const Uuid().v4(),
      imagePath: imagePath,
      ocrText: ocrText,
      confidence: confidence,
      language: language,
      createdAt: DateTime.now(),
    );

    _documents.insert(0, doc);
    _saveDocument(doc);
    notifyListeners();
    return doc;
  }

  Future<void> deleteDocument(String id) async {
    _documents.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  Future<void> _saveDocument(ScannedDocument doc) async {
    final docDir = Directory('${Platform.environment['HOME'] ?? '/tmp'}/docscan/documents');
    if (!await docDir.exists()) {
      await docDir.create(recursive: true);
    }
    final file = File('${docDir.path}/${doc.id}.json');
    await file.writeAsString(jsonEncode(doc.toJson()));
  }
}