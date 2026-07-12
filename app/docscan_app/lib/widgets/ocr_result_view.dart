import 'package:flutter/material.dart';

class OcrResultView extends StatelessWidget {
  final String text;

  const OcrResultView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.text_fields, size: 64, color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'No text extracted',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // RTL Arabic text display
          Directionality(
            textDirection: TextDirection.rtl,
            child: SelectableText.rich(
              TextSpan(
                children: _buildTextSpans(text, colorScheme),
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Cairo',
                    height: 1.8,
                    fontSize: 18,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          // English/transliteration version (LTR)
          Directionality(
            textDirection: TextDirection.ltr,
            child: SelectableText(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(String text, ColorScheme colorScheme) {
    final spans = <TextSpan>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].trim().isNotEmpty) {
        spans.add(TextSpan(text: lines[i]));
      }
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }
}