import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/document_provider.dart';
import '../providers/scan_provider.dart';
import '../widgets/document_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DocScan Arab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, docProvider, _) {
          if (docProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (docProvider.documents.isEmpty) {
            return _buildEmptyState(context, colorScheme);
          }

          return _buildDocumentList(context, docProvider);
        },
      ),
      // FAB as main scan button — prominent and always visible
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Reset any previous scan state before starting a new scan
          context.read<ScanProvider>().reset();
          if (context.mounted) {
            await context.push('/scan');
          }
        },
        icon: const Icon(Icons.document_scanner),
        label: const Text('Scan'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.document_scanner_outlined,
              size: 96,
              color: colorScheme.outlineVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'No Documents Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the Scan button to scan your\nfirst Arabic document',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentList(BuildContext context, DocumentProvider docProvider) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: docProvider.documents.length,
      itemBuilder: (context, index) {
        final doc = docProvider.documents[index];
        return DocumentCard(
          document: doc,
          onTap: () {
            context.push('/result', extra: {'imagePath': doc.imagePath});
          },
          onDelete: () {
            docProvider.deleteDocument(doc.id);
          },
        );
      },
    );
  }
}