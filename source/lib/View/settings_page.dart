// lib/views/main_app/settings_page.dart
import 'package:flutter/material.dart';
import 'package:superx/main.dart'; // Make sure this import path is correct

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Mock state variables
  bool _notifications = true;
  bool _analytics = false;
  String _defaultModel = 'Quark Standard';
  String _language = 'English';
  double _dataRetentionDays = 30;

  final _models = ['Quark Standard', 'Quark Pro'];
  final _languages = ['English', 'हिन्दी',];

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved (demo)')));
  }

  void _resetSettings() {
    setState(() {
      _notifications = true;
      _analytics = false;
      _defaultModel = 'Quark Standard';
      _language = 'English';
      _dataRetentionDays = 30;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings reset to defaults (demo)')));
  }

  Future<void> _confirmClearCache() async { /* ... same as before ... */ }
  Future<void> _confirmFactoryReset() async { /* ... same as before ... */ }

  @override
  Widget build(BuildContext context) {
    // We get the theme brightness once to avoid calling it repeatedly
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme and Notification Card
          Card(
            child: Column(children: [
              SwitchListTile.adaptive(
                value: !isLightTheme,
                onChanged: (v) {
                  // Connect to your global theme changer
                  MyApp.of(context).changeTheme(v ? ThemeMode.dark : ThemeMode.light);
                },
                title: const Text('Dark mode'),
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              SwitchListTile.adaptive(
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
                title: const Text('Notifications'),
                secondary: const Icon(Icons.notifications_outlined),
              ),
              SwitchListTile.adaptive(
                value: _analytics,
                onChanged: (v) => setState(() => _analytics = v),
                title: const Text('Usage analytics'),
                subtitle: const Text('Share anonymous usage data'),
                secondary: const Icon(Icons.insights_outlined),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          
          // App Behavior Card
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.memory_outlined),
                  title: const Text('Default model'),
                  subtitle: Text(_defaultModel),
                  trailing: DropdownButton<String>(
                    value: _defaultModel,
                    items: _models.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (v) => setState(() => _defaultModel = v ?? _defaultModel),
                    underline: Container(), // Hides the default underline for a cleaner look
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(_language),
                  trailing: DropdownButton<String>(
                    value: _language,
                    items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) => setState(() => _language = v ?? _language),
                    underline: Container(),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text('Clear cache'),
                  onTap: _confirmClearCache,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Data and Reset Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Data retention'),
                  Text('Automatically delete history older than ${_dataRetentionDays.round()} days', style: Theme.of(context).textTheme.bodySmall),
                  Slider.adaptive(
                    min: 1,
                    max: 365,
                    divisions: 12,
                    value: _dataRetentionDays,
                    onChanged: (v) => setState(() => _dataRetentionDays = v),
                  ),
                  const Divider(height: 24),

                  // --- FIX: Replaced Row with Wrap to prevent overflow ---
                  Wrap(
                    spacing: 12.0, // Horizontal space between items
                    runSpacing: 8.0,  // Vertical space if items wrap
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.warning_amber_rounded),
                        label: const Text('Factory reset'),
                        onPressed: _confirmFactoryReset,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800, foregroundColor: Colors.white),
                      ),
                      OutlinedButton(
                        onPressed: _resetSettings,
                        child: const Text('Reset settings')
                      ),
                      Text('App v1.0.0', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 18),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('About Quark'),
            subtitle: const Text('Terms, privacy & licenses'),
            onTap: () => showAboutDialog(context: context, applicationName: 'Quark', applicationVersion: '1.0.0'),
          ),
        ],
      ),
    );
  }
}