// lib/code_assistant_screen.dart
// Final Version — Explain opens as plain formatted text (no cards), prompt clears on Generate,
// rounded inputs, keyboard-safe layout, expand for editor and output.

import 'package:flutter/material.dart';
import 'package:superx/Controller/groq_functions.dart';

// ---------------- MAIN SCREEN ----------------
class CodeAssistantScreen extends StatefulWidget {
  const CodeAssistantScreen({super.key});

  @override
  State<CodeAssistantScreen> createState() => _CodeAssistantScreenState();
}

class _CodeAssistantScreenState extends State<CodeAssistantScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _stdinController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _codeScroll = ScrollController();
  final ScrollController _outputScroll = ScrollController();

  final _groq = GroqService(apiKey: GROQ_API_KEY);

  String _output = '';
  bool _busyExplain = false;
  bool _busyFix = false;
  bool _busyRun = false;
  bool _busyGenerate = false;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // Extract code from fenced block
  String _extractCode(String res) {
    final fence = '```';
    if (!res.contains(fence)) return res.trim();
    final first = res.indexOf(fence);
    var after = res.substring(first + 3);
    final second = after.indexOf(fence);
    if (second != -1) after = after.substring(0, second);
    return after.trim();
  }

  // ---------- Generate ----------
  Future<void> _generateCode() async {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;
    setState(() => _busyGenerate = true);

    final prompt = '''
You are a professional code generator and programming assistant.

User request:
$text

If the user wants code, return only the code in a fenced block (```).
If not code, return the best relevant text, concise.
''';

    final res =
        await _groq.chat(prompt, model: MODEL_PLACEHOLDER, temperature: 0.2);
    final code = _extractCode(res);
    setState(() {
      _codeController.text = code;
      _busyGenerate = false;
      _promptController.clear(); // clear prompt after generation
    });
  }

  // ---------- Explain ----------
  Future<void> _explainCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      _snack('Paste or generate code first.');
      return;
    }
    setState(() => _busyExplain = true);

    final prompt = '''
You are a code explanation assistant.
Explain the following code line-by-line in plain English.
Guidelines:
- For each meaningful line, restate the line (briefly) and explain its purpose in 1–2 simple sentences.
- Group multi-line constructs (like loops or functions) into short, readable sections.
- Avoid markdown tables or complex formatting. Use short paragraphs and bullet points sparingly.
- Keep it beginner-friendly and practical.

Code:
$code
''';

    final res = await _groq.chat(prompt, model: MODEL_PLACEHOLDER, temperature: 0.0, maxTokens: 2000);
    setState(() => _busyExplain = false);

    if (!mounted) return;
    // Show as plain, readable text (no cards)
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _FullScreenText(title: 'Explanation', text: res.trim())),
    );
  }

  // ---------- Fix ----------
  Future<void> _fixCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => _busyFix = true);

    final prompt = '''
Fix any syntax or logical issues in this code.
Return only the corrected version in a single fenced block.

Code:
$code
''';

    final res =
        await _groq.chat(prompt, model: MODEL_PLACEHOLDER, temperature: 0.1, maxTokens: 1400);
    final fixed = _extractCode(res);
    setState(() {
      _codeController.text = fixed;
      _busyFix = false;
    });
  }

  // ---------- Run (Simulated) ----------
  Future<void> _runCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    setState(() => _busyRun = true);

    final input = _stdinController.text.trim();
    final prompt = '''
Simulate running this program and show the expected output (text only).
If behavior is ambiguous, state minimal assumptions first, then output.
If the code would error, show the likely error message.

Code:
$code

Input (stdin):
$input
''';

    final res = await _groq.chat(prompt, model: MODEL_PLACEHOLDER, temperature: 0.0, maxTokens: 1000);
    setState(() {
      _output = res.trim();
      _busyRun = false;
    });
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Code Assistant'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- CODE EDITOR ----
              _roundedBox(
                context,
                height: 260,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Scrollbar(
                        controller: _codeScroll,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _codeScroll,
                          child: TextField(
                            controller: _codeController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                fontFamily: 'monospace', fontSize: 14),
                            decoration: const InputDecoration.collapsed(
                                hintText: 'Write or paste code here...'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.open_in_full),
                        onPressed: () async {
                          final result = await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      _FullScreenEditor(text: _codeController.text)));
                          if (result != null) {
                            setState(() => _codeController.text = result);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ---- EXPLAIN + FIX ----
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _busyExplain ? null : _explainCode,
                      icon: _busyExplain
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.menu_book_outlined),
                      label: const Text('Explain'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _busyFix ? null : _fixCode,
                      icon: _busyFix
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.build_circle_outlined),
                      label: const Text('Fix'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ---- INPUT + RUN ----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stdinController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Program input (stdin)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 75,
                    child: ElevatedButton.icon(
                      onPressed: _busyRun ? null : _runCode,
                      icon: _busyRun
                          ? const SizedBox(
                              width: 18,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.play_arrow),
                      label: const Text('Run'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ---- OUTPUT BOX ----
              _roundedBox(
                context,
                height: 180,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Scrollbar(
                        controller: _outputScroll,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _outputScroll,
                          child: SelectableText(
                            _output.isEmpty
                                ? 'Output will appear here...'
                                : _output,
                            style: const TextStyle(
                                fontFamily: 'monospace', fontSize: 13.5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.open_in_full),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) =>
                                  _FullScreenText(title: 'Output', text: _output)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ---- PROMPT INPUT ----
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      decoration: InputDecoration(
                        hintText:
                            'Write a prompt (generated code replaces editor)...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _generateCode(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _busyGenerate ? null : _generateCode,
                      icon: _busyGenerate
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.auto_fix_high),
                      label: const Text('Generate'),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Rounded box builder
  Widget _roundedBox(BuildContext context,
      {required double height, required Widget child}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
    );
  }
}

// ---------------- SUPPORTING WIDGETS ----------------

class _FullScreenEditor extends StatelessWidget {
  final String text;
  const _FullScreenEditor({required this.text});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pop(context, controller.text.trim()),
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          decoration: const InputDecoration.collapsed(
              hintText: 'Edit your code here...'),
        ),
      ),
    );
  }
}

class _FullScreenText extends StatelessWidget {
  final String title;
  final String text;
  const _FullScreenText({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              text.isEmpty ? '(No content)' : text,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// GroqService moved to groq_functions.dart
