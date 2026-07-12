import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../providers/document_provider.dart';
import '../services/export_service.dart';
import '../widgets/ocr_result_view.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;

  const ResultScreen({super.key, required this.imagePath});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runOcr();
    });
  }

  Future<void> _runOcr() async {
    final scanProvider = context.read<ScanProvider>();
    await scanProvider.scanImage(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _isExporting ? null : _shareResult,
          ),
        ],
      ),
      body: Consumer<ScanProvider>(
        builder: (context, scanProvider, _) {
          if (scanProvider.isScanning) {
            return _buildLoadingState(colorScheme);
          }

          if (scanProvider.state == ScanState.error) {
            return _buildErrorState(colorScheme, scanProvider.error);
          }

          if (scanProvider.state == ScanState.completed && scanProvider.lastResult != null) {
            return _buildResultView(colorScheme, scanProvider);
          }

          return const Center(child: Text('Ready to scan'));
        },
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(strokeWidth: 4),
          ),
          const SizedBox(height: 24),
          Text(
            'Processing document...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Extracting Arabic text',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, String? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: colorScheme.error),
            const SizedBox(height: 24),
            Text(
              'OCR Failed',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _runOcr,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: const Text('Back Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(ColorScheme colorScheme, ScanProvider scanProvider) {
    final result = scanProvider.lastResult!;

    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
          ),
          child: Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: colorScheme.surfaceContainerLow,
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                '${result.lines.length} lines extracted',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              if (result.hasTashkeel)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Tashkeel ✓',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.amber.shade800,
                        ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: OcrResultView(text: result.rawText),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isExporting ? null : _saveAndFinish,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isExporting ? null : () => _copyText(result.rawText),
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _shareResult() async {
    final scanProvider = context.read<ScanProvider>();
    if (scanProvider.lastResult == null) return;

    setState(() => _isExporting = true);
    await ExportService.shareText(scanProvider.lastResult!.rawText, 'docscan_result');
    setState(() => _isExporting = false);
  }

  Future<void> _saveAndFinish() async {
    final scanProvider = context.read<ScanProvider>();
    final docProvider = context.read<DocumentProvider>();

    if (scanProvider.lastResult == null) return;

    setState(() => _isExporting = true);

    await docProvider.addDocument(
      imagePath: widget.imagePath,
      ocrText: scanProvider.lastResult!.rawText,
      confidence: scanProvider.lastResult!.averageConfidence,
      language: 'ara',
    );

    setState(() => _isExporting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go('/');
    }
  }

  void _copyText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}