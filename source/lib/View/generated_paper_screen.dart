// lib/views/dashboard/paper_viewer_screen.dart
import 'package:flutter/material.dart';// Import our new model
import 'dart:async';

import 'package:superx/Model/chat_model.dart';

class PaperViewerScreen extends StatefulWidget {
  final Map<String, dynamic> paperData;

  const PaperViewerScreen({super.key, required this.paperData});

  @override
  State<PaperViewerScreen> createState() => _PaperViewerScreenState();
}

class _PaperViewerScreenState extends State<PaperViewerScreen> {
  // --- State Variables for Chat ---
  final List<ChatMessage> _messages = [];
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isBotReplying = false;

  // Mock paper content
  final String _mockPaperContent = """
**Section A: Short Answer Questions (5 Marks Each)**
1. Explain the concept of gradient descent in machine learning.
2. What is the difference between supervised and unsupervised learning? Provide an example of each.
3. Describe the role of an activation function in a neural network.

**Section B: Long Answer Questions (10 Marks Each)**
4. Discuss the architecture of a Convolutional Neural Network (CNN) and explain how it is used for image recognition tasks.
5. What are the advantages and disadvantages of using a Support Vector Machine (SVM) compared to a Decision Tree for classification problems?
""";

  @override
  void initState() {
    super.initState();
    // Add an initial message from the bot
    _messages.add(
      ChatMessage(
        text: "Here is the paper you generated. Feel free to ask me anything about it!",
        sender: ChatSender.bot,
      ),
    );
  }
  
  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- Functionality for Sending a Message ---
  void _sendMessage() {
    final text = _chatController.text;
    if (text.isEmpty) return;

    // Add user message to the list
    setState(() {
      _messages.add(ChatMessage(text: text, sender: ChatSender.user));
      _isBotReplying = true;
    });

    _chatController.clear();
    _scrollToBottom();

    // Simulate bot reply
    _getBotReply();
  }

  // --- Simulate a delayed reply from the bot ---
  Future<void> _getBotReply() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _messages.add(
        ChatMessage(
          text: "That's a great question! Let me analyze that for you... (Simulation)",
          sender: ChatSender.bot,
        ),
      );
      _isBotReplying = false;
    });
    _scrollToBottom();
  }

  // --- Automatically scroll to the latest message ---
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      appBar: AppBar(title: Text(widget.paperData['title'] ?? 'Generated Paper')),
      body: Column(
        children: [
          // --- Top Area: Scrollable Paper Content and Chat History ---
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Paper Content Display
                  Text('Generated Paper', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_mockPaperContent, style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  const Divider(height: 40),

                  // Chat History Display
                  Text('Chat About This Paper', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  ListView.builder(
                    itemCount: _messages.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
                  if (_isBotReplying) _buildTypingIndicator(),
                ],
              ),
            ),
          ),

          // --- Bottom Area: Chat Input Field ---
          _buildChatInputField(),
        ],
      ),
    );
  }

  // --- Helper Widgets for UI ---

  Widget _buildChatInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _chatController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ask about the paper...',
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    bool isUserMessage = message.sender == ChatSender.user;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Theme.of(context).primaryColor
              : Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUserMessage
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text("Quark is typing..."),
      ),
    );
  }
}