// lib/views/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:superx/Controller/DB_Controller.dart';
import 'package:superx/Controller/Firebase_Controller.dart';
import 'package:superx/Controller/database_controller.dart'; 
import 'package:superx/View/chat_screen.dart'; 
import 'package:superx/View/place(TEMP).dart';
import 'package:superx/View/saved_chat_screen.dart';
import 'package:superx/Widgets/chat_popup.dart';
import 'package:superx/Widgets/custom_drawer.dart';
import 'package:superx/View/tools_screen.dart';
import 'package:superx/View/account_section_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late Future<String?> _usernameFuture;
  final FirebaseController _fbController = FirebaseController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _usernameFuture = _fbController.getUsername();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- NAVIGATION FIX ---
  // Using dynamic for sessionId to prevent strict type errors during the call
  void _navigateToChat(BuildContext context, {ChatMode mode = ChatMode.general, dynamic sessionId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(mode: mode, sessionId: sessionId is String ? int.tryParse(sessionId) : sessionId),
      ),
    ).then((_) => _refreshData());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final String username = snapshot.data ?? 'User';
        final hour = DateTime.now().hour;
        final String greeting = hour < 12 ? 'Good Morning' : (hour < 17 ? 'Good Afternoon' : 'Good Evening');

        final List<Widget> tabPages = <Widget>[
          _HomeTabContent(onNavigate: _navigateToChat, refreshTrigger: _refreshData),
          const ToolsScreen(),
          const SavedChatsScreen(),
          const AccountSectionScreen(),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1706997770544-049a30962ae6?w=500&auto=format&fit=crop&q=60&ixlib-rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cm90YXJ5JTIwZW5naW5lJTIwY2FyfGVufDB8fDB8fHww'),
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(greeting, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                Text(username, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Notifications'))),
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          //drawer: const CustomDrawer(),
          body: IndexedStack(index: _selectedIndex, children: tabPages),
          bottomNavigationBar: _buildBottomNavBar(context),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.black54.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.build_outlined), activeIcon: Icon(Icons.build), label: 'Tools'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), activeIcon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey,
          elevation: 0,
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  final Function(BuildContext, {ChatMode mode, dynamic sessionId}) onNavigate;
  final VoidCallback refreshTrigger;

  const _HomeTabContent({required this.onNavigate, required this.refreshTrigger});

  Future<int> _getUpdatedStreak() async {
    int currentStreak = await DbController.getStreakCount();
    String? lastDateStr = await DbController.getLastActivityDate();
    
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (lastDateStr != null) {
      DateTime lastDate = DateTime.parse(lastDateStr);
      DateTime lastActivityDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final difference = today.difference(lastActivityDay).inDays;

      if (difference > 1) {
        await DbController.updateStreak(0);
        return 0;
      }
    }
    return currentStreak;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: [
                  FutureBuilder<int>(
                    future: ChatDatabase.instance.getTodayPromptCount(),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return _buildStatCard(context, title: 'Prompts Used', content: CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 8.0,
                        animation: true,
                        percent: (count / 20).clamp(0.0, 1.0),
                        center: Text("$count/20", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        circularStrokeCap: CircularStrokeCap.round,
                      ));
                    },
                  ),
                  FutureBuilder<int>(
                    future: _getUpdatedStreak(),
                    builder: (context, snapshot) {
                      // final streak = snapshot.data ?? 3;

                      final streak = 1;


                      return _buildStatCard(context, title: 'Study Streak', content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_fire_department_rounded, color: streak > 0 ? Colors.orange.shade700 : Colors.grey, size: 48),
                          Text('$streak Days', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ],
                      ));
                    },
                  ),
                ],
              ),
              _buildSectionHeader(context, 'Quick Actions'),
              _buildQuickActions(context),
              _buildSectionHeader(context, 'Recent Chats'),
              
              // --- RECENT CHATS FIX ---
              FutureBuilder<List<Map<String, dynamic>>>(
                future: ChatDatabase.instance.getRecentSessions(3),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const LinearProgressIndicator();
                  final chats = snapshot.data ?? [];
                  if (chats.isEmpty) return _buildEmptyRecentState(context);

                  return Column(
                    children: chats.map((chat) {
                      // Extracting as int? to match ChatScreen constructor
                      final int? sId = chat['session_id'] as int?; 
                      
                      return _buildRecentChatItem(
                        context, 
                        title: chat['header'] ?? "New Discussion", 
                        subtitle: "Last active: ${chat['last_active']?.toString().substring(11, 16) ?? 'N/A'}",
                        sessionId: sId,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _buildQuickHelpButton(context)),
      ],
    );
  }

  Widget _buildEmptyRecentState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(Icons.chat_bubble_outline, color: Colors.grey.withOpacity(0.5), size: 40),
        const SizedBox(height: 12),
        Text("No recent activity", style: TextStyle(color: Colors.grey.shade600)),
      ]),
    );
  }

  Widget _buildQuickHelpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20, top: 40),
      child: GestureDetector(
        onTap: () => _showChatEntryOptions(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary, 
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text('Quick Help...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ),
      ),
    );
  }

  void _showChatEntryOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 12),
            Container(height: 5, width: 45, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            ListTile(
              leading: const Icon(Icons.flash_on, color: Colors.blue),
              title: const Text('Start Instant Chat'),
              onTap: () {
                Navigator.pop(context);
                onNavigate(context, mode: ChatMode.general);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tune, color: Colors.purple),
              title: const Text('Customize Chat'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(context: context, builder: (_) => const CustomizedChatPopup()).then((_) => refreshTrigger());
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
  }

  Widget _buildStatCard(BuildContext context, {required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Expanded(child: Center(child: content)),
      ]),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _buildActionItem(context, Icons.summarize, 'Summary', ChatMode.summarize),
      _buildActionItem(context, Icons.translate, 'Translate', ChatMode.translate),
      _buildActionItem(context, Icons.spellcheck, 'Grammar', ChatMode.grammar),
      _buildActionItem(context, Icons.psychology, 'Explain', ChatMode.explain),
    ]);
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, ChatMode mode) {
    return Column(children: [
      InkWell(
        onTap: () => onNavigate(context, mode: mode),
        child: CircleAvatar(radius: 28, backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1), child: Icon(icon, color: Theme.of(context).primaryColor)),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }

  Widget _buildRecentChatItem(BuildContext context, {required String title, required String subtitle, required dynamic sessionId}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.chat_bubble_outline),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onNavigate(context, sessionId: sessionId),
      ),
    );
  }
}