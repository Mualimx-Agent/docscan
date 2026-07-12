import 'dart:io';
import 'package:flutter/material.dart';

class ScanPreview extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onRetake;

  const ScanPreview({
    super.key,
    required this.imagePath,
    this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath),
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.broken_image, size: 48)),
            ),
          ),
        ),
        // Retake button
        if (onRetake != null)
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: onRetake,
              ),
            ),
          ),
      ],
    );
  }
}