import 'dart:async';
import 'package:flutter/material.dart';
import 'package:superx/Controller/groq_controller.dart';
import 'package:superx/Widgets/chat_history_drawer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// --- RENAMED: InternalChatDb to avoid naming conflicts ---
class InternalChatDb {
  static final InternalChatDb instance = InternalChatDb._init();
  static Database? _database;
  InternalChatDb._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quark_ultimate_v1.db'); 
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath); 
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        header TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        isSaved INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId INTEGER,
        text TEXT NOT NULL,
        isUser INTEGER,
        FOREIGN KEY (sessionId) REFERENCES sessions (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE usage_limit (
        date TEXT PRIMARY KEY,
        count INTEGER DEFAULT 0
      )
    ''');
  }

  // --- METHODS FOR CONTINUITY ---
  Future<List<Map<String, dynamic>>> getMessages(int sessionId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'id ASC',
    );
  }

  Future<int> getTodayPromptCount() async {
    final db = await instance.database;
    final String today = DateTime.now().toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'usage_limit',
      where: 'date = ?',
      whereArgs: [today],
    );
    return maps.isEmpty ? 0 : maps.first['count'] as int;
  }

  Future<void> incrementPromptCount() async {
    final db = await instance.database;
    final String today = DateTime.now().toIso8601String().split('T')[0];
    await db.rawInsert('''
      INSERT INTO usage_limit(date, count) VALUES(?, 1)
      ON CONFLICT(date) DO UPDATE SET count = count + 1
    ''', [today]);
  }

  Future<int> createSession(String firstPrompt) async {
    final db = await instance.database;
    return await db.insert('sessions', {'header': firstPrompt});
  }

  Future<void> insertMessage(int sessionId, String text, bool isUser) async {
    final db = await instance.database;
    await db.insert('messages', {'sessionId': sessionId, 'text': text, 'isUser': isUser ? 1 : 0});
  }
}

// --- Main Chat Screen ---
enum ChatMode { general, summarize, translate, grammar, explain, purelyAnswer, generateQuiz, custom }
enum QuarkModel { standard, pro }

class ChatScreen extends StatefulWidget {
  final ChatMode mode;
  final int? sessionId; // Added to support loading old chats
  final Map<String, dynamic>? customData;

  const ChatScreen({super.key, required this.mode, this.sessionId, this.customData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  QuarkModel _selectedModel = QuarkModel.standard;
  bool _isPremiumUser = false; 
  bool _hasStartedChat = false;
  bool _isTyping = false;
  int? _currentSessionId;

  @override
  void initState() {
    super.initState();
    // Logic to load history if we opened a previous chat
    if (widget.sessionId != null) {
      _loadChatHistory();
    }
  }

  Future<void> _loadChatHistory() async {
    final history = await InternalChatDb.instance.getMessages(widget.sessionId!);
    setState(() {
      _currentSessionId = widget.sessionId;
      _hasStartedChat = true;
      _messages.addAll(history.map((m) => _ChatMessage(
            text: m['text'],
            isUser: m['isUser'] == 1,
          )));
    });
    _scrollToBottom();
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Daily Limit Reached"),
        content: const Text(
          "You've reached your limit of 20 prompts for today. "
          "Come back tomorrow or upgrade to Pro for unlimited access!"
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Later")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Upgrade to Pro")
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    if (!_isPremiumUser) {
      final count = await InternalChatDb.instance.getTodayPromptCount();
      if (count >= 20) {
        _showLimitReachedDialog();
        return;
      }
    }

    final userMsg = _ChatMessage(text: text, isUser: true);

    setState(() {
      _messages.add(userMsg);
      _chatController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      if (!_hasStartedChat) {
        _currentSessionId = await InternalChatDb.instance.createSession(text);
        setState(() => _hasStartedChat = true);
      }

      if (_currentSessionId != null) {
        await InternalChatDb.instance.insertMessage(_currentSessionId!, text, true);
      }

      final reply = await ChatController.sendMessage(userMessage: text);

      if (!_isPremiumUser) {
        await InternalChatDb.instance.incrementPromptCount();
      }

      if (_currentSessionId != null) {
        await InternalChatDb.instance.insertMessage(_currentSessionId!, reply, false);
      }

      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: reply, isUser: false));
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: e.toString(), isUser: false));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ChatHistoryDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: GestureDetector(
          onTap: _showModelSelector,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quark', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: !_hasStartedChat
                ? _buildWelcomeArea(widget.mode)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == _messages.length) {
                        return const _TypingIndicator();
                      }
                      final msg = _messages[index];
                      return _AnimatedMessageBubble(message: msg);
                    },
                  ),
          ),
          _buildChatInputField(),
        ],
      ),
    );
  }

  Widget _buildWelcomeArea(ChatMode mode) {
    final Map<ChatMode, Map<String, dynamic>> details = {
      ChatMode.summarize: {'title': 'Summarize', 'icon': Icons.summarize_outlined},
      ChatMode.translate: {'title': 'Translate', 'icon': Icons.translate_outlined},
      ChatMode.grammar: {'title': 'Check Grammar', 'icon': Icons.spellcheck_outlined},
      ChatMode.explain: {'title': 'Explain a Topic', 'icon': Icons.history_edu_outlined},
      ChatMode.purelyAnswer: {'title': 'Get Answers', 'icon': Icons.question_answer_outlined},
      ChatMode.generateQuiz: {'title': 'Generate a Quiz', 'icon': Icons.quiz_outlined},
    };

    if (details.containsKey(mode)) {
      return _buildToolWelcome(context, title: details[mode]!['title'], icon: details[mode]!['icon']);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hello, Keter", style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).primaryColor)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip(context, 'Summarize', onTap: () => setState(() => _hasStartedChat = true)),
              _buildSuggestionChip(context, 'Explain', onTap: () => setState(() => _hasStartedChat = true)),
              _buildSuggestionChip(context, 'Purely Answer', onTap: () => setState(() => _hasStartedChat = true)),
              _buildSuggestionChip(context, 'Generate Quiz', onTap: () => setState(() => _hasStartedChat = true)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildToolWelcome(BuildContext context, {required String title, required IconData icon}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text, {required VoidCallback onTap}) {
    return ActionChip(label: Text(text), onPressed: onTap, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8));
  }

  Widget _buildChatInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add), onPressed: _showAttachmentMenu, tooltip: "Attach files"),
            Expanded(
              child: TextField(
                controller: _chatController,
                decoration: InputDecoration(
                  hintText: 'Ask Quark...',
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(icon: const Icon(Icons.mic_none), onPressed: () {}, tooltip: "Voice input"),
            IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
          ],
        ),
      ),
    );
  }

  void _showModelSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewPadding.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select Model', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildModelSelectionCard(context: context, title: 'Quark Standard', subtitle: 'Great for everyday tasks.', icon: Icons.auto_awesome_outlined, isSelected: _selectedModel == QuarkModel.standard, onTap: () { setState(() => _selectedModel = QuarkModel.standard); Navigator.pop(context); }),
                  const SizedBox(height: 12),
                  _buildModelSelectionCard(context: context, title: 'Quark Pro', subtitle: _isPremiumUser ? 'Your advanced model for complex reasoning.' : 'Upgrade to Pro to unlock.', icon: Icons.star_rounded, isPro: true, isSelected: _selectedModel == QuarkModel.pro, onTap: _isPremiumUser ? () { setState(() => _selectedModel = QuarkModel.pro); Navigator.pop(context); } : null),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModelSelectionCard({required BuildContext context, required String title, required String subtitle, required IconData icon, required bool isSelected, required VoidCallback? onTap, bool isPro = false}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3), width: isSelected ? 2 : 1)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: isPro ? Colors.amber.shade600 : Theme.of(context).primaryColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium),
                        if (isPro) ...[
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber.shade600, borderRadius: BorderRadius.circular(4)), child: const Text('PRO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onTap == null ? Colors.grey : null)),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: Theme.of(context).primaryColor) else Icon(Icons.radio_button_unchecked, color: Colors.grey.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.description_outlined), title: const Text('Upload Document'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.photo_library_outlined), title: const Text('Choose from Gallery'), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.camera_alt_outlined), title: const Text('Take Photo'), onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// --- SUB WIDGETS ---
class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class _AnimatedMessageBubble extends StatefulWidget {
  final _ChatMessage message;
  const _AnimatedMessageBubble({required this.message});
  @override
  State<_AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<_AnimatedMessageBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400))..forward();
    _slide = Tween<Offset>(begin: widget.message.isUser ? const Offset(0.2, 0) : const Offset(-0.2, 0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Align(
          alignment: widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: widget.message.isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant.withOpacity(0.7),
              borderRadius: BorderRadius.only(topLeft: const Radius.circular(16), topRight: const Radius.circular(16), bottomLeft: Radius.circular(widget.message.isUser ? 16 : 4), bottomRight: Radius.circular(widget.message.isUser ? 4 : 16)),
            ),
            child: Text(widget.message.text, style: TextStyle(color: widget.message.isUser ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color)),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with TickerProviderStateMixin {
  late final List<AnimationController> _dots;
  @override
  void initState() {
    super.initState();
    _dots = List.generate(3, (i) => AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true, period: const Duration(milliseconds: 900)));
  }
  @override
  void dispose() { for (final d in _dots) { d.dispose(); } super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant.withOpacity(0.7), borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16), bottomRight: Radius.circular(16))),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) {
          return AnimatedBuilder(animation: _dots[i], builder: (_, __) => Opacity(opacity: 0.4 + (0.6 * _dots[i].value), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Container(width: 6, height: 6, decoration: BoxDecoration(color: theme.colorScheme.onSurfaceVariant, shape: BoxShape.circle)))));
        }))),
    );
  }
}