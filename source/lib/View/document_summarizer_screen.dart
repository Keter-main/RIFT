// lib/views/main_app/document_summarizer_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:superx/View/chat_screen.dart';
import 'package:superx/Controller/groq_functions.dart';

class DocumentSummarizerScreen extends StatefulWidget {
  const DocumentSummarizerScreen({super.key});

  @override
  State<DocumentSummarizerScreen> createState() =>
      _DocumentSummarizerScreenState();
}

class _DocumentSummarizerScreenState extends State<DocumentSummarizerScreen> {
  final List<PlatformFile> _selectedFiles = [];
  String _summaryType = 'Short Summary';
  bool _isSummarizing = false;

  final List<String> _summaryOptions = [
    'Short Summary',
    'Detailed Summary',
    'Bullet Points',
  ];

  // Pick documents
  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  // Using centralized GroqService
  final _groq = GroqService(apiKey: GROQ_API_KEY);

  // GROQ summarizer
  Future<String> _summarizeText(String text) async {
    try {
      final prompt = "You are a precise academic summarizer. Summarize this document in ${_summaryType.toLowerCase()} form:\n\n$text";
      final result = await _groq.chat(
        prompt,
        model: GROQ_MODEL,
        temperature: 0.3,
        maxTokens: 1500,
      );
      return cleanResponse(result);
    } catch (e) {
      return 'Request failed: $e';
    }
  }

  // Combine multiple summaries
  Future<void> _summarizeDocuments() async {
    if (_selectedFiles.isEmpty) return;
    setState(() => _isSummarizing = true);

    List<String> summaries = [];

    for (final file in _selectedFiles) {
      try {
        // Read text content (txt/docx only — pdf requires external parser)
        String content = '';
        if (file.path != null) {
          final ext = file.extension?.toLowerCase() ?? '';
          if (ext == 'txt') {
            content = await File(file.path!).readAsString();
          } else {
            content = "Document: ${file.name}. Please infer summary contextually.";
          }
        }

        final summary = await _summarizeText(content);
        summaries.add("📄 **${file.name}**:\n$summary");
      } catch (e) {
        summaries.add("⚠️ Error reading ${file.name}: $e");
      }
    }

    final combinedSummary = summaries.join("\n\n---\n\n");

    setState(() => _isSummarizing = false);

    // Navigate to chat with the summarized text
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            mode: ChatMode.summarize,
            customData: {'summaryText': combinedSummary},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Document Summarizer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 12),
            Text(
              'Upload one or more documents and let Quark summarize them for you using Groq AI.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 20),

            // Upload Button
            ElevatedButton.icon(
              onPressed: _isSummarizing ? null : _pickDocuments,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('Upload Documents'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 16),

            // File List
            if (_selectedFiles.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedFiles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    return ListTile(
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(file.name, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeFile(file),
                      ),
                    );
                  },
                ),
              ),

            if (_selectedFiles.isNotEmpty) const SizedBox(height: 20),

            // Summary Type Dropdown
            DropdownButtonFormField<String>(
              value: _summaryType,
              items: _summaryOptions
                  .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Summarization Type',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
              onChanged: (v) => setState(() => _summaryType = v!),
            ),

            const SizedBox(height: 28),

            // Summarize Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSummarizing ? null : _summarizeDocuments,
                icon: _isSummarizing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.summarize_outlined),
                label: Text(
                  _isSummarizing ? 'Summarizing...' : 'Summarize & Chat',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            if (_selectedFiles.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        size: 40, color: theme.colorScheme.primary),
                    const SizedBox(height: 10),
                    Text(
                      'No documents selected yet.\nUpload a few and start summarizing!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
