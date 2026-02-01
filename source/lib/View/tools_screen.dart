// lib/views/main_app/tools_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:superx/View/chat_screen.dart';
import 'package:superx/View/code_assisstant_screen.dart';
import 'package:superx/View/document_summarizer_screen.dart';
import 'package:superx/View/exam_customizer.dart';
import 'package:superx/View/place(TEMP).dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  late final List<_ToolItem> _allTools;
  List<_ToolItem> _filteredTools = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allTools = <_ToolItem>[
      _ToolItem(
        icon: Icons.edit_document,
        title: 'Exam Customizer',
        routeName: '/exam_customizer',
      ),
      _ToolItem(
        icon: Icons.assignment_outlined,
        title: 'Assignment Helper',
        routeName: '/assignment_helper',
      ),
      _ToolItem(
        icon: Icons.code_outlined,
        title: 'Code Assistant',
        routeName: '/code_assistant',
      ),
      _ToolItem(
        icon: Icons.summarize_outlined,
        title: 'Document Summarizer',
        routeName: '/chat_summarize',
      ),
      _ToolItem(
        icon: Icons.quiz_outlined,
        title: 'Quiz Generator',
        routeName: '/chat_custom',
      ),
      _ToolItem(
        icon: Icons.book_outlined,
        title: 'Study Notes Builder',
        routeName: '/chat_custom',
      ),
    ];

    _filteredTools = List.from(_allTools);
    _searchController.addListener(_filterTools);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTools);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTools() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTools = List.from(_allTools);
      } else {
        _filteredTools = _allTools
            .where((t) => t.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // 🧭 Navigation logic for each tool
  void _navigateForTool(BuildContext context, _ToolItem tool) {
    switch (tool.routeName) {
      case '/exam_customizer':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ExamCustomizerScreen()),
        );
        break;

      case '/chat_summarize':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DocumentSummarizerScreen()),
        );
        break;

      case '/assignment_helper':
        _showAssignmentHelperPopup(context);
        break;

      case '/code_assistant':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CodeAssistantScreen()),
        );
        break;

      case '/chat_custom':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ChatScreen(mode: ChatMode.custom)),
        );
        break;

      default:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Tool')),
        );
    }
  }

  // 📘 Assignment Helper Popup
  Future<void> _showAssignmentHelperPopup(BuildContext context) async {
    final TextEditingController _topicController = TextEditingController();
    List<PlatformFile> _selectedFiles = [];

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.assignment_outlined, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Assignment Helper',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _topicController,
                        decoration: const InputDecoration(
                          labelText: 'Assignment Topic or Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.upload_file_outlined),
                        label: const Text('Upload Documents'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
                          );
                          if (result != null) {
                            setState(() {
                              _selectedFiles = result.files;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      if (_selectedFiles.isNotEmpty)
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _selectedFiles
                                .map(
                                  (f) => Row(
                                    children: [
                                      const Icon(Icons.description_outlined, size: 18),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          f.name,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(mode: ChatMode.custom),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate'),
            ),
          ],
        );
      },
    );
  }

  // 🧱 Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tools',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).hintColor),
                prefixIcon: const Icon(Icons.search_outlined),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: _filteredTools.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, idx) {
                  final t = _filteredTools[idx];
                  return Card(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () => _navigateForTool(context, t),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              shape: const CircleBorder(),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  t.icon,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              t.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String title;
  final String routeName;

  _ToolItem({
    required this.icon,
    required this.title,
    required this.routeName,
  });
}
