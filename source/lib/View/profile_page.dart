// lib/views/profile/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  // controllers for editable fields
  late final TextEditingController _nameCtl;
  late final TextEditingController _emailCtl;
  late final TextEditingController _phoneCtl;
  late final TextEditingController _bioCtl;

  bool _editing = false;
  String _avatar =
      'https://images.unsplash.com/photo-1706997770544-049a30962ae6?w=500&auto=format&fit=crop&q=60';
  String _subscription = 'Quark Standard';
  bool _emailVerified = true;

  // small demo stats
  int _promptsUsed = 7;
  int _totalPrompts = 20;
  int _streak = 3;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController(text: 'Keter');
    _emailCtl = TextEditingController(text: 'keter@example.com');
    _phoneCtl = TextEditingController(text: '+91 98765 43210');
    _bioCtl = TextEditingController(text: 'I build and tinker with generative AI prototypes.');
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _bioCtl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _editing = !_editing);
  }

  Future<void> _save() async {
    // simple local validation
    if (_nameCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved (demo)')));
  }

  Future<void> _changeAvatar() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Choose from gallery (demo)'), onTap: () => Navigator.of(ctx).pop('gallery')),
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Take photo (demo)'), onTap: () => Navigator.of(ctx).pop('camera')),
            ListTile(leading: const Icon(Icons.person), title: const Text('Use placeholder avatar'), onTap: () => Navigator.of(ctx).pop('placeholder')),
          ],
        ),
      ),
    );

    if (choice == null) return;
    setState(() {
      if (choice == 'placeholder') {
        _avatar = 'https://images.unsplash.com/photo-1531123414780-f99d7f8008e3?w=500&auto=format&fit=crop&q=60';
      } else if (choice == 'gallery') {
        _avatar = 'https://images.unsplash.com/photo-1545996124-1b0d19fb7c8c?w=500&auto=format&fit=crop&q=60';
      } else {
        _avatar = 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500&auto=format&fit=crop&q=60';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Avatar updated (demo)')));
  }

  Future<void> _changePassword() async {
    final oldCtl = TextEditingController();
    final newCtl = TextEditingController();
    final confirmCtl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: oldCtl, obscureText: true, decoration: const InputDecoration(labelText: 'Current password')),
            const SizedBox(height: 8),
            TextField(controller: newCtl, obscureText: true, decoration: const InputDecoration(labelText: 'New password')),
            const SizedBox(height: 8),
            TextField(controller: confirmCtl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm new password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newCtl.text.length < 6 || newCtl.text != confirmCtl.text) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password validation failed')));
                return;
              }
              Navigator.of(ctx).pop(true);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );

    if (ok == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed (demo)')));
    }
  }

  Future<void> _exportData() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export data'),
        content: const Text('Prepare export of account data (demo).'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Export')),
        ],
      ),
    );
    if (ok == true) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export started (demo)')));
  }

  Future<void> _deleteAccount() async {
    final textCtl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This will permanently delete your account. Type DELETE to confirm.'),
            const SizedBox(height: 12),
            TextField(controller: textCtl, decoration: const InputDecoration(hintText: 'Type DELETE')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (textCtl.text.trim().toUpperCase() == 'DELETE') {
                Navigator.of(ctx).pop(true);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Type DELETE to confirm')));
              }
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Deleted (demo)'),
          content: const Text('Account removed in demo environment.'),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final promptPercent = (_promptsUsed / _totalPrompts).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _editing
                ? TextButton(
                    key: const ValueKey('save'),
                    onPressed: _save,
                    child: Text('Save', style: TextStyle(color: cs.onSurface)),
                  )
                : TextButton(
                    key: const ValueKey('edit'),
                    onPressed: _toggleEdit,
                    child: Text('Edit', style: TextStyle(color: cs.onSurface)),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card: avatar, name, email, subscription, stats
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _changeAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))],
                            ),
                            child: CircleAvatar(
                              key: ValueKey(_avatar),
                              radius: 46,
                              backgroundImage: NetworkImage(_avatar),
                              backgroundColor: cs.surface,
                            ),
                          ),
                          Material(
                            color: cs.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _changeAvatar,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.edit, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // name + email
                    AnimatedSize(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: [
                          _editing
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: TextFormField(controller: _nameCtl, textAlign: TextAlign.center, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), decoration: const InputDecoration(border: InputBorder.none)),
                                )
                              : Text(_nameCtl.text, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          const SizedBox(height: 6),
                          _editing
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: TextFormField(controller: _emailCtl, textAlign: TextAlign.center, decoration: const InputDecoration(border: InputBorder.none)),
                                )
                              : Text(_emailCtl.text, style: textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.8))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // subscription & small stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          backgroundColor: _subscription == 'Quark Pro' ? cs.primary : cs.surface,
                          label: Text(_subscription, style: TextStyle(color: _subscription == 'Quark Pro' ? cs.onPrimary : cs.onSurface)),
                        ),
                        const SizedBox(width: 12),
                        _miniStat('${_promptsUsed}/${_totalPrompts}', 'Prompts'),
                        const SizedBox(width: 8),
                        _miniStat('$_streak', 'Streak'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Details card: phone, bio, editable inline when in edit mode
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    _detailRow(label: 'Phone', icon: Icons.phone, child: _editing ? _editField(_phoneCtl, hint: 'Phone') : Text(_phoneCtl.text)),
                    const Divider(),
                    _detailRow(label: 'Bio', icon: Icons.info_outline, child: _editing ? _editField(_bioCtl, maxLines: 3, hint: 'Short bio') : Text(_bioCtl.text, maxLines: 3)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Security & data actions
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Change password'),
                    subtitle: const Text('Update your account password'),
                    onTap: _changePassword,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.download_outlined),
                    title: const Text('Export data'),
                    subtitle: const Text('Get a copy of your account data (demo)'),
                    onTap: _exportData,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Danger / delete area
            Card(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Align(alignment: Alignment.centerLeft, child: Text('Danger zone', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text('Delete account', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Recent activity - compact list
            Text('Recent activity', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._recentActivityTiles(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _detailRow({required String label, required IconData icon, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 36, child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              child,
            ]),
          ),
        ],
      ),
    );
  }

  Widget _editField(TextEditingController ctl, {int maxLines = 1, String? hint}) {
    return TextFormField(
      controller: ctl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<Widget> _recentActivityTiles() {
    final now = DateTime.now();
    final items = [
      {'title': 'Created chat: Heisenberg Qs', 'time': now.subtract(const Duration(hours: 3))},
      {'title': 'Upgraded to Pro (demo)', 'time': now.subtract(const Duration(days: 2))},
      {'title': 'Updated profile', 'time': now.subtract(const Duration(days: 5))},
    ];

    return items
        .map((e) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                title: Text(e['title'] as String),
                subtitle: Text(_ago(e['time'] as DateTime)),
              ),
            ))
        .toList();
  }

  String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}
