import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.document_scanner,
      title: 'Scan Documents',
      subtitle: 'Point your camera at any document\nand scan it instantly.',
      arTitle: 'مسح المستندات',
      arSubtitle: 'وجه الكاميرا نحو أي مستند\nوامسحه ضوئياً فوراً.',
      deTitle: 'Dokumente scannen',
      deSubtitle: 'Richten Sie Ihre Kamera auf ein Dokument\nund scannen Sie es sofort.',
    ),
    _OnboardingPage(
      icon: Icons.translate,
      title: 'Arabic OCR',
      subtitle: 'Extract Arabic text with high accuracy.\nPreserves Tashkeel & RTL layout.',
      arTitle: 'التعرف على النص العربي',
      arSubtitle: 'استخرج النص العربي بدقة عالية.\nيحافظ على التشكيل والترتيب من اليمين لليسار.',
      deTitle: 'Arabische OCR',
      deSubtitle: 'Extrahiert arabischen Text mit hoher\nGenauigkeit. Erhält Tashkeel & RTL-Layout.',
    ),
    _OnboardingPage(
      icon: Icons.privacy_tip,
      title: '100% Private',
      subtitle: 'All processing happens on your device.\nNo data ever leaves your phone.',
      arTitle: 'خصوصية تامة',
      arSubtitle: 'جميع المعالجة تتم على جهازك.\nلا تغادر أي بيانات هاتفك أبداً.',
      deTitle: '100% Privat',
      deSubtitle: 'Alle Verarbeitung erfolgt auf Ihrem Gerät.\nKeine Daten verlassen je Ihr Telefon.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onComplete() async {
    await context.read<SettingsProvider>().completeOnboarding();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onComplete,
                child: Text(_currentPage == 2 ? 'ابدأ' : 'تخطي'),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page.icon, size: 120, color: colorScheme.primary),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Arabic version
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            page.arSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontFamily: 'Cairo',
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots + Button
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => Container(
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == i
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onComplete();
                        }
                      },
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'التالي'
                            : 'ابدأ المسح',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String arTitle;
  final String arSubtitle;
  final String deTitle;
  final String deSubtitle;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.arTitle,
    required this.arSubtitle,
    required this.deTitle,
    required this.deSubtitle,
  });
}