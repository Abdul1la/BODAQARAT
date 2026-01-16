import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatelessWidget {
  static const routeName = '/theme-settings';

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onModeChanged;

  const ThemeSettingsPage({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          const Text(
            'Choose how the app should look. Dark mode keeps your design accents but dims the surfaces.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildOption(
            context,
            title: 'Light',
            subtitle: 'Use the classic bright experience',
            mode: ThemeMode.light,
          ),
          _buildOption(
            context,
            title: 'Dark',
            subtitle: 'Use the dimmed palette—perfect for night viewing',
            mode: ThemeMode.dark,
          ),
          _buildOption(
            context,
            title: 'System',
            subtitle: 'Follow the device setting automatically',
            mode: ThemeMode.system,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required ThemeMode mode,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: RadioListTile<ThemeMode>(
        value: mode,
        groupValue: currentMode,
        onChanged: (value) {
          if (value != null) {
            onModeChanged(value);
          }
        },
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
