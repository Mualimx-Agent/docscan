import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Language section
              _SectionHeader(title: 'Language / اللغة'),
              const SizedBox(height: 8),
              _LanguageTile(
                label: 'English',
                code: 'en',
                flag: '🇬🇧',
                isSelected: settings.appLanguage == AppLanguage.english,
                onTap: () => settings.setLanguage(AppLanguage.english),
              ),
              _LanguageTile(
                label: 'Deutsch',
                code: 'de',
                flag: '🇩🇪',
                isSelected: settings.appLanguage == AppLanguage.german,
                onTap: () => settings.setLanguage(AppLanguage.german),
              ),
              _LanguageTile(
                label: 'العربية',
                code: 'ar',
                flag: '🇸🇦',
                isSelected: settings.appLanguage == AppLanguage.arabic,
                onTap: () => settings.setLanguage(AppLanguage.arabic),
              ),

              const SizedBox(height: 32),

              // Appearance section
              _SectionHeader(title: 'Appearance'),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Use dark theme'),
                  value: settings.darkMode,
                  onChanged: (v) => settings.setDarkMode(v),
                  secondary: Icon(
                    settings.darkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About section
              _SectionHeader(title: 'Info'),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About DocScan Arab'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/about'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('100% offline — no data leaves your device'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'DocScan Arab',
                      applicationVersion: '1.0.0',
                      children: [
                        const Text(
                          'Privacy Commitment:\n\n'
                          '• All processing is done 100% offline on your device\n'
                          '• No data is ever sent to any server\n'
                          '• No tracking SDKs or analytics\n'
                          '• No account required\n'
                          '• Your documents never leave your phone',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String code;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.code,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 28)),
        title: Text(label),
        subtitle: Text(code == 'ar' ? 'اليمين إلى اليسار' : code == 'de' ? 'Rechts-nach-Links' : 'Right-to-Left'),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}