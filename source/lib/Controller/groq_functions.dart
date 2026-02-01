// lib/Controller/groq_functions.dart
// Centralized Groq/AI functions for the Quark application

import 'dart:convert';
import 'package:http/http.dart' as http;

// ================== CONFIGURATION ==================
const String GROQ_API_KEY = '';
const String GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';
const String GROQ_MODEL = 'openai/gpt-oss-120b';
const String DOC_MODEL = 'mixtral-8x7b';

// Aliases for backward compatibility
const String CHAT_MODEL = GROQ_MODEL;
const String MODEL_PLACEHOLDER = GROQ_MODEL;

// ================== GROQ SERVICE ==================
/// Generic Groq API service for making chat completions
class GroqService {
  final String apiKey;
  final http.Client _client = http.Client();
  
  GroqService({required this.apiKey});

  Future<String> chat(String prompt,
      {String model = GROQ_MODEL,
      double temperature = 0.2,
      int maxTokens = 1500}) async {
    try {
      final res = await _client.post(
        Uri.parse(GROQ_API_URL),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': temperature,
          'max_tokens': maxTokens,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['choices']?[0]?['message']?['content'] ?? 'No response content.';
      } else {
        return 'Groq API Error ${res.statusCode}: ${res.body}';
      }
    } catch (e) {
      return 'Request failed: $e';
    }
  }
}

// ================== CHAT CONTROLLER ==================
/// Controller for the main chat functionality
class ChatController {
  static Future<String> sendMessage({
    required String userMessage,
    double temperature = 0.6,
    int maxTokens = 1000,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(GROQ_API_URL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $GROQ_API_KEY',
        },
        body: jsonEncode({
          "model": GROQ_MODEL,
          "messages": [
            {
              "role": "system",
              "content": "You are Quark, a helpful AI assistant."
            },
            {
              "role": "user",
              "content": userMessage
            }
          ],
          "temperature": temperature,
          "max_tokens": maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return cleanReply(
          data['choices'][0]['message']['content']
              ?.toString()
              .trim() ??
              "No response received.",
        );
      } else {
        throw Exception(
          'Groq API Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to Groq API: $e');
    }
  }
}

// ================== UTILITY FUNCTIONS ==================

/// Cleans reply text for chat display
String cleanReply(String text) {
  return text
      .replaceAll('*', '')
      .replaceAll('_', '')
      .replaceAll('```', '')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll('\\n', '\n')
      .replaceAll(RegExp(r'\s{3,}'), '\n\n')
      .trim();
}

/// Cleans output text for exam paper display
String cleanOutput(String text) {
  return text
      // HTML-like tags
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</?p>', caseSensitive: false), '\n')
      // Escaped and literal newlines
      .replaceAll('\\n', '\n')
      .replaceAll('\r', '\n')
      // Markdown and formatting symbols
      .replaceAll('*', '')
      .replaceAll('_', '')
      .replaceAll('#', '')
      .replaceAll('```', '')
      .replaceAll('---', '')
      // Extra whitespace cleanup
      .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n')
      .replaceAll(RegExp(r' {2,}'), ' ')
      .trim();
}

/// Cleans response text for document summarizer
String cleanResponse(String text) {
  return text
      .replaceAll('*', '')
      .replaceAll('```', '')
      .replaceAll('\\n', '\n')
      .replaceAll('<br>', '\n')
      .replaceAll(RegExp(r'\s{3,}'), '\n\n')
      .trim();
}
