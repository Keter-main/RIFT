// lib/views/chat/widgets/chat_history_drawer.dart
import 'package:flutter/material.dart';
import 'package:superx/Controller/database_controller.dart';

class ChatHistoryDrawer extends StatefulWidget {
  const ChatHistoryDrawer({super.key});

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  
  // Logic to toggle save status in DB
  Future<void> _toggleSaveStatus(int sessionId, bool currentStatus) async {
    final newStatus = !currentStatus;
    await ChatDatabase.instance.toggleSave(sessionId, newStatus);
    
    setState(() {}); // Refresh the list
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus ? 'Chat saved!' : 'Chat unsaved.'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chat History', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'New Chat',
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ChatDatabase.instance.getRecentSessions(20),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final sessions = snapshot.data!;
                  if (sessions.isEmpty) {
                    return const Center(child: Text("No chats yet", style: TextStyle(color: Colors.grey)));
                  }

                  // Grouping logic
                  final now = DateTime.now();
                  final todaySessions = sessions.where((s) {
                    final date = DateTime.parse(s['timestamp']);
                    return date.day == now.day && date.month == now.month && date.year == now.year;
                  }).toList();

                  final olderSessions = sessions.where((s) => !todaySessions.contains(s)).toList();

                  return ListView(
                    children: [
                      if (todaySessions.isNotEmpty) ...[
                        _buildDateHeader('Today'),
                        ...todaySessions.map((s) => _buildChatItem(s)),
                      ],
                      if (olderSessions.isNotEmpty) ...[
                        _buildDateHeader('Previous'),
                        ...olderSessions.map((s) => _buildChatItem(s)),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> session) {
    final int id = session['id'];
    final String title = session['header'];
    final bool isSaved = session['isSaved'] == 1;

    return ListTile(
      leading: const Icon(Icons.chat_bubble_outline, size: 20),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: () {
        // Here you would typically load the session into the ChatScreen
        Navigator.pop(context); 
      },
      trailing: IconButton(
        icon: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: isSaved ? Theme.of(context).primaryColor : Colors.grey,
        ),
        onPressed: () => _toggleSaveStatus(id, isSaved),
        tooltip: isSaved ? 'Unsave Chat' : 'Save Chat',
      ),
    );
  }

  Widget _buildDateHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold, 
          color: Colors.grey
        ),
      ),
    );
  }
}