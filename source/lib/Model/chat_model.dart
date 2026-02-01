// lib/models/chat_message_model.dart

enum ChatSender { user, bot }

class ChatMessage {
  final String text;
  final ChatSender sender;

  ChatMessage({
    required this.text,
    required this.sender,
  });
}