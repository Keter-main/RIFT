import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superx/Controller/DB_Controller.dart';
import 'package:superx/Controller/auth_controller.dart';
import 'package:superx/Controller/database_controller.dart';
import 'package:superx/View/login_screen.dart';
import 'package:superx/View/profile_page.dart'; 
// IMPORTANT: Ensure this path is correct for your project


class AccountSectionScreen extends StatefulWidget {
  const AccountSectionScreen({super.key});

  @override
  State<AccountSectionScreen> createState() => _AccountSectionScreenState();
}

class _AccountSectionScreenState extends State<AccountSectionScreen> {
  // Demo user state
  String userName = 'Aryan Patil';
  String userEmail = 'aryanpatil5712@gmail.com';
  String avatarUrl =
      'https://images.unsplash.com/photo-1706997770544-049a30962ae6?w=500';

  int totalPrompts = 20;
  bool isPro = false;
  bool isLoggedIn = true;
  DateTime memberSince = DateTime(2025, 9, 12);

  /// 📅 Calculate streak from 'usage_limit' table in SQFlite
  Future<int> _calculateStreak() async {
    try {
      final db = await ChatDatabase.instance.database;
      final List<Map<String, dynamic>> result = await db.query(
        'usage_limit',
        orderBy: 'date DESC',
      );
      if (result.isEmpty) return 0;

      int streak = 0;
      DateTime today = DateTime.now();
      DateTime checkDate = DateTime(today.year, today.month, today.day);

      for (var row in result) {
        DateTime entryDate = DateTime.parse(row['date']);
        if (entryDate == checkDate || entryDate == checkDate.subtract(const Duration(days: 1))) {
          streak++;
          checkDate = entryDate;
        } else {
          break;
        }
      }
      return streak;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ListView(
          children: [
            _buildProfileTop(context),
            const SizedBox(height: 18),
            
            // 🔄 Live Database Integration
            FutureBuilder(
              future: Future.wait([
                ChatDatabase.instance.getTodayPromptCount(),
                _calculateStreak(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                int used = snapshot.data?[0] ?? 0;
                int streak = snapshot.data?[1] ?? 0;
                return _buildUsageSummary(context, used, streak);
              },
            ),

            const SizedBox(height: 16),
            // Daily Activity Box Removed per instructions
            _buildAccountActionsCard(context),
            const SizedBox(height: 14),
            _buildMetadataCard(context),
            const SizedBox(height: 36),
            _buildDangerZone(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _openEditProfile,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(userEmail, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(label: Text(isPro ? 'Quark Pro' : 'Quark Standard')),
                  const SizedBox(width: 8),
                  Icon(isLoggedIn ? Icons.verified : Icons.login_outlined, size: 18),
                ],
              )
            ],
          ),
        ),
        IconButton(
          onPressed: _openEditProfile,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }

  Widget _buildUsageSummary(BuildContext context, int used, int streak) {
    double percent = (used / totalPrompts).clamp(0.0, 1.0);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showUsageDetails(used, streak),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 48.0,
                lineWidth: 8.0,
                percent: percent,
                center: Text('$used/$totalPrompts', style: const TextStyle(fontWeight: FontWeight.bold)),
                progressColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prompts Used', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('$used of $totalPrompts used', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: percent),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const Icon(Icons.local_fire_department_rounded, size: 28, color: Colors.orange),
                  const SizedBox(height: 6),
                  Text('$streak days', style: Theme.of(context).textTheme.bodyMedium),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountActionsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history_edu_outlined),
            title: const Text('Activity'),
            subtitle: const Text('View your local sessions'),
            onTap: _openActivityScreen,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Subscription'),
            subtitle: Text(isPro ? 'Active (Quark Pro)' : 'Quark Standard'),
            trailing: TextButton(
              onPressed: _showSubscriptionScreen, 
              child: Text(isPro ? 'Details' : 'Upgrade')
            ),
            onTap: _showSubscriptionScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildKeyValueRow('Member Since', '${memberSince.day}-${memberSince.month}-${memberSince.year}'),
            const Divider(),
            _buildKeyValueRow('Email', userEmail),
            const Divider(),
            _buildKeyValueRow('App Version', '1.0.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: _confirmSignOut,
          child: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _clearDatabase,
          child: const Text('Clear Database', style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  Widget _buildKeyValueRow(String key, String value) {
    return Row(
      children: [
        Expanded(child: Text(key, style: const TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }

  // -----------------------
  // Logic & Actions
  // -----------------------

  void _clearDatabase() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Database'),
        content: const Text('This will delete all sessions, messages, and prompt history permanently.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final db = await ChatDatabase.instance.database;
              await db.delete('sessions');
              await db.delete('messages');
              await db.delete('usage_limit');
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database Cleared')));
            },
            child: const Text('Clear', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SubscriptionScreen(isPro: isPro)),
    );
  }

  void _showUsageDetails(int used, int streak) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewPadding.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usage & Stats', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text('CURRENT CYCLE', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey)),
            const SizedBox(height: 8),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: used / totalPrompts,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              progressColor: Theme.of(context).primaryColor,
              barRadius: const Radius.circular(10),
            ),
            const SizedBox(height: 8),
            Text('$used of $totalPrompts prompts used.'),
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.local_fire_department_rounded, color: Colors.orange.shade600, size: 32),
              title: const Text('Current Study Streak'),
              trailing: Text('$streak Days', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const Divider(height: 32),
            Card(
              elevation: 0,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.star_border, color: Colors.amber),
                title: const Text("Upgrade to Quark Pro"),
                subtitle: const Text("Get unlimited prompts!"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showSubscriptionScreen();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openActivityScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActivityScreen()));
  }
void _confirmSignOut() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // 1. Firebase Sign out
            await AuthController().signOut();

            // 2. Clear Local Session Data
            final prefs = await SharedPreferences.getInstance();
            
            // ✅ This is the critical line: 
            // It turns off the "green light" your LoginPage is looking for
            await prefs.setBool('is_logged_in', false);
            
            // Also clear the UID and other session data for safety
            await prefs.remove('uid');
            await prefs.remove('user_email');

            if (mounted) {
              // 3. Wipe the navigation stack completely
              // (route) => false ensures the user cannot hit "Back" to return
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            }
          },
          child: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
  void _openEditProfile() async {
    final result = await Navigator.of(context).push<Map<String, String>?>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(name: userName, email: userEmail, avatarUrl: avatarUrl),
      ),
    );
    if (result != null) {
      setState(() {
        userName = result['name'] ?? userName;
        userEmail = result['email'] ?? userEmail;
      });
    }
  }
}

// ---------------------------------------------------------
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ChatDatabase.instance.getRecentSessions(50),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return const Center(child: Text('No sessions yet.'));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              final item = snapshot.data![i];
              return Card(
                child: ListTile(
                  title: Text(item['header']),
                  subtitle: Text(item['timestamp'].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
class SubscriptionScreen extends StatelessWidget {
  final bool isPro;
  const SubscriptionScreen({super.key, required this.isPro});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: cs.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(isPro ? 'You are on Quark Pro' : 'Upgrade to Quark Pro', 
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Unlimited prompts, priority responses, and premium models.', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    if (!isPro)
                      ElevatedButton(
                        onPressed: () {}, // Simulated upgrade
                        child: const Text('Get Pro Plan'),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------
class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String avatarUrl;
  const EditProfileScreen({super.key, required this.name, required this.email, required this.avatarUrl});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _n;
  late TextEditingController _e;

  @override
  void initState() {
    super.initState();
    _n = TextEditingController(text: widget.name);
    _e = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), actions: [
        TextButton(onPressed: () => Navigator.pop(context, {'name': _n.text, 'email': _e.text}), child: const Text('Save'))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _n, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _e, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
      ),
    );
  }
}