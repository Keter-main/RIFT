// lib/view/saved_chats_screen.dart
import 'package:flutter/material.dart';
import 'package:superx/Controller/database_controller.dart';
import 'package:superx/View/chat_screen.dart';

class SavedChatsScreen extends StatefulWidget {
  const SavedChatsScreen({super.key});

  @override
  State<SavedChatsScreen> createState() => _SavedChatsScreenState();
}

class _SavedChatsScreenState extends State<SavedChatsScreen> {
  late Future<List<Map<String, dynamic>>> _savedChatsFuture;

  @override
  void initState() {
    super.initState();
    _loadSavedChats();
  }

  void _loadSavedChats() {
    setState(() {
      _savedChatsFuture = ChatDatabase.instance.getAllSavedSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Chats'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSavedChats,
          ), // Fixed closing bracket here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Your Archive',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _savedChatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final chats = snapshot.data ?? [];

                  if (chats.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final int sessionId = chat['session_id'];
                      final String title = chat['header'] ?? 'Untitled Conversation';
                      final String timestamp = chat['last_active']?.toString().split(' ')[0] ?? 'Recently';

                      return _buildChatCard(context, sessionId, title, timestamp);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ), // Removed the extra closing parenthesis here
    );
  }

  Widget _buildChatCard(BuildContext context, int sessionId, String title, String date) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            title.isNotEmpty ? title[0].toUpperCase() : '?',
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('Saved on $date', style: const TextStyle(fontSize: 12)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'delete') {
              await ChatDatabase.instance.deleteSession(sessionId);
              _loadSavedChats();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(mode: ChatMode.general, sessionId: sessionId),
            ),
          ).then((_) => _loadSavedChats());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('No saved chats yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Important chats you keep will appear here.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}