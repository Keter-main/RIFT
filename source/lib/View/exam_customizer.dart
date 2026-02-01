// // lib/views/dashboard/exam_customizer_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:superx/View/generated_paper_screen.dart';

// class ExamCustomizerScreen extends StatefulWidget {
//   const ExamCustomizerScreen({super.key});

//   @override
//   State<ExamCustomizerScreen> createState() => _ExamCustomizerScreenState();
// }

// class _ExamCustomizerScreenState extends State<ExamCustomizerScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;

//   String? _selectedUniversity = 'SPPU'; // fixed
//   String? _selectedCourse;
//   String? _selectedYear;
//   String? _selectedSubject;

//   final _titleController = TextEditingController();
//   final _marksController = TextEditingController();
//   final _durationController = TextEditingController();

//   final List<String> _courses = [
//     'Computer Engineering',
//     'Information Technology',
//     'AI & Data Science'
//   ];

//   final List<String> _years = ['2nd Year', '3rd Year', '4th Year'];

//   // 🔹 OFFICIAL SPPU 2019 PATTERN SUBJECTS
//   final Map<String, Map<String, List<String>>> _subjectsByCourse = {
//     'Computer Engineering': {
//       '2nd Year': [
//         'Data Structures and Algorithms',
//         'Digital Electronics and Logic Design',
//         'Computer Organization and Architecture',
//         'Engineering Mathematics III',
//         'Object Oriented Programming',
//         'Fundamentals of Data Structures Laboratory',
//         'Digital Electronics Lab',
//         'OOP Lab',
//       ],
//       '3rd Year': [
//         'Theory of Computation',
//         'Database Management Systems',
//         'Computer Networks',
//         'Software Engineering',
//         'Web Technology',
//         'Data Science & Big Data Analytics',
//         'Information Systems and Design',
//         'Laboratory Practice I',
//         'Laboratory Practice II',
//       ],
//       '4th Year': [
//         'Machine Learning',
//         'Artificial Intelligence',
//         'Cloud Computing',
//         'Data Mining',
//         'Cyber Security',
//         'Elective I: Deep Learning / NLP / IoT / Blockchain',
//         'Elective II: High Performance Computing / Robotics / AR-VR',
//         'Project Stage I',
//         'Project Stage II',
//       ],
//     },
//     'Information Technology': {
//       '2nd Year': [
//         'Data Structures & Files',
//         'Computer Organization',
//         'Object Oriented Programming',
//         'Digital Electronics',
//         'Engineering Mathematics III',
//         'Data Structures Lab',
//         'OOP Lab',
//       ],
//       '3rd Year': [
//         'Computer Networks',
//         'Software Engineering',
//         'Database Management Systems',
//         'Web Technologies',
//         'Operating Systems',
//         'IT Workshop',
//         'Open Elective (AI / ML Fundamentals)',
//       ],
//       '4th Year': [
//         'Information and Network Security',
//         'Cloud Computing',
//         'Data Analytics',
//         'Internet of Things',
//         'Software Testing & Quality Assurance',
//         'Project Stage I',
//         'Project Stage II',
//         'Elective: Blockchain / Big Data / NLP / AR-VR',
//       ],
//     },
//     'AI & Data Science': {
//       '2nd Year': [
//         'Data Structures',
//         'Linear Algebra',
//         'Probability and Statistics for Data Science',
//         'Object Oriented Programming in Python',
//         'Database Management Systems',
//         'Data Science Lab',
//         'Python Programming Lab',
//       ],
//       '3rd Year': [
//         'Machine Learning',
//         'Data Mining',
//         'Computer Vision',
//         'Big Data Analytics',
//         'Artificial Neural Networks',
//         'Natural Language Processing',
//         'Laboratory Practice I',
//         'Laboratory Practice II',
//       ],
//       '4th Year': [
//         'Deep Learning',
//         'Reinforcement Learning',
//         'Advanced Machine Learning',
//         'Cloud & Edge Computing for AI',
//         'Research Methodology in AI',
//         'Capstone Project',
//       ],
//     },
//   };

//   final List<PlatformFile> _uploadedFiles = [];

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _marksController.dispose();
//     _durationController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickFiles() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
//       );

//       if (result != null) {
//         setState(() {
//           _uploadedFiles.addAll(result.files);
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error picking files: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _handleGeneratePaper() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final paperData = {
//       'university': _selectedUniversity,
//       'course': _selectedCourse,
//       'year': _selectedYear,
//       'subject': _selectedSubject,
//       'title': _titleController.text,
//       'marks': _marksController.text,
//       'duration': _durationController.text,
//       'file_names': _uploadedFiles.map((f) => f.name).toList(),
//     };

//     print('--- Generating Paper with the following data ---');
//     print(paperData);

//     await Future.delayed(const Duration(seconds: 3));
//     setState(() => _isLoading = false);

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Paper generated successfully!')),
//       );
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => PaperViewerScreen(paperData: paperData),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Exam Customizer')),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionHeader('Academic Context'),
//               TextFormField(
//                 initialValue: _selectedUniversity,
//                 decoration: const InputDecoration(labelText: 'University'),
//                 readOnly: true,
//               ),
//               const SizedBox(height: 12),

//               // Course
//               _buildDropdown(
//                 'Select Course',
//                 _selectedCourse,
//                 _courses,
//                 (val) => setState(() {
//                   _selectedCourse = val;
//                   _selectedYear = null;
//                   _selectedSubject = null;
//                 }),
//               ),
//               const SizedBox(height: 12),

//               // Year + Subject row
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildDropdown(
//                       'Select Year',
//                       _selectedYear,
//                       _years,
//                       (val) => setState(() {
//                         _selectedYear = val;
//                         _selectedSubject = null;
//                       }),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildDropdown(
//                       'Select Subject',
//                       _selectedSubject,
//                       (_selectedCourse != null && _selectedYear != null)
//                           ? _subjectsByCourse[_selectedCourse]![_selectedYear]!
//                           : [],
//                       (val) => setState(() => _selectedSubject = val),
//                     ),
//                   ),
//                 ],
//               ),

//               _buildSectionHeader('Paper Details'),
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(labelText: 'Paper Title'),
//                 validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
//               ),
//               const SizedBox(height: 12),

//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _marksController,
//                       decoration: const InputDecoration(labelText: 'Total Marks'),
//                       keyboardType: TextInputType.number,
//                       validator: (v) => v!.isEmpty ? 'Required' : null,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _durationController,
//                       decoration: const InputDecoration(labelText: 'Duration (min)'),
//                       keyboardType: TextInputType.number,
//                       validator: (v) => v!.isEmpty ? 'Required' : null,
//                     ),
//                   ),
//                 ],
//               ),

//               _buildSectionHeader('Source Material'),
//               OutlinedButton.icon(
//                 icon: const Icon(Icons.upload_file_outlined),
//                 label: const Text('Upload Syllabus & Assignments'),
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   foregroundColor: Theme.of(context).primaryColor,
//                   side: BorderSide(color: Theme.of(context).primaryColor),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: _pickFiles,
//               ),
//               const SizedBox(height: 8),

//               if (_uploadedFiles.isEmpty)
//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 8.0),
//                   child: Text(
//                     'Add source files for better answers.',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ..._uploadedFiles.map((file) => _buildUploadedFileTile(context, file)),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: _isLoading ? null : _handleGeneratePaper,
//           style: ElevatedButton.styleFrom(
//             minimumSize: const Size(double.infinity, 50),
//             textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           child: _isLoading
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         strokeWidth: 2,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text('Generating...'),
//                   ],
//                 )
//               : const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.auto_awesome, size: 20),
//                     SizedBox(width: 8),
//                     Text('Generate Paper'),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
//       child: Text(title, style: Theme.of(context).textTheme.titleLarge),
//     );
//   }

//   Widget _buildDropdown(
//     String label,
//     String? value,
//     List<String>? items,
//     ValueChanged<String?> onChanged,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         isExpanded: true,
//         decoration: InputDecoration(labelText: label),
//         items: items != null
//             ? items
//                 .map((String item) => DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(item, overflow: TextOverflow.ellipsis),
//                     ))
//                 .toList()
//             : [],
//         onChanged: onChanged,
//         validator: (v) => v == null ? 'Please make a selection' : null,
//       ),
//     );
//   }

//   Widget _buildUploadedFileTile(BuildContext context, PlatformFile file) {
//     return Card(
//       margin: const EdgeInsets.only(top: 8),
//       elevation: 0,
//       color: Theme.of(context).inputDecorationTheme.fillColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Icon(Icons.description_outlined, color: Theme.of(context).primaryColor),
//         title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
//         subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB'),
//         trailing: IconButton(
//           icon: const Icon(Icons.close, size: 20),
//           onPressed: () => setState(() => _uploadedFiles.remove(file)),
//         ),
//       ),
//     );
//   }
// }

// lib/views/dashboard/exam_customizer_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:superx/Controller/groq_functions.dart';

// ---------------- MAIN SCREEN ----------------
class ExamCustomizerScreen extends StatefulWidget {
  const ExamCustomizerScreen({super.key});

  @override
  State<ExamCustomizerScreen> createState() => _ExamCustomizerScreenState();
}

class _ExamCustomizerScreenState extends State<ExamCustomizerScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _selectedUniversity = 'SPPU';
  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedSubject;

  final _titleController = TextEditingController();
  final _marksController = TextEditingController();
  final _durationController = TextEditingController();

  final List<String> _courses = [
    'Computer Engineering',
    'Information Technology',
    'AI & Data Science'
  ];
  final List<String> _years = ['2nd Year', '3rd Year', '4th Year'];

  final Map<String, Map<String, List<String>>> _subjectsByCourse = {
    'Computer Engineering': {
      '2nd Year': [
        'Data Structures and Algorithms',
        'Object Oriented Programming',
        'Digital Electronics',
      ],
      '3rd Year': [
        'Computer Networks',
        'Software Engineering',
        'Database Management Systems',
      ],
      '4th Year': [
        'Artificial Intelligence',
        'Machine Learning',
        'Cloud Computing'
      ],
    },
    'Information Technology': {
      '2nd Year': ['OOP', 'Computer Organization', 'Data Structures'],
      '3rd Year': ['Web Tech', 'OS', 'DBMS'],
      '4th Year': ['Cloud Computing', 'Cyber Security', 'IoT'],
    },
    'AI & Data Science': {
      '2nd Year': ['Data Structures', 'Python OOP', 'DBMS'],
      '3rd Year': ['Machine Learning', 'Data Mining', 'NLP'],
      '4th Year': ['Deep Learning', 'Reinforcement Learning', 'Capstone Project']
    }
  };

  final List<PlatformFile> _uploadedFiles = [];
  final GroqService _groq = GroqService(apiKey: GROQ_API_KEY);

  // ---------------- FILE PICKER ----------------
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );
      if (result != null) setState(() => _uploadedFiles.addAll(result.files));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ---------------- GENERATE PAPER ----------------
  Future<void> _handleGeneratePaper() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    List<String> extractedTexts = [];

    for (final f in _uploadedFiles) {
      try {
        final prompt =
            "Summarize the important syllabus and academic content from this document. Focus only on topics.";
        final response = await _groq.chat(prompt,
            model: DOC_MODEL, temperature: 0.2, maxTokens: 800);
        extractedTexts.add(response);
      } catch (e) {
        debugPrint("Error reading file: $e");
      }
    }

    final prompt = '''
You are an expert question paper generator for SPPU (2019 pattern).
Prepare a professional, well-balanced exam paper.

University: ${_selectedUniversity ?? "SPPU"}
Course: ${_selectedCourse ?? ""}
Year: ${_selectedYear ?? ""}
Subject: ${_selectedSubject ?? ""}
Title: ${_titleController.text}
Marks: ${_marksController.text}
Duration: ${_durationController.text} minutes

Include:
- Section I: Q1-Q4 (Short theoretical questions)
- Section II: Q5-Q8 (Long answer or problem solving)
- Marks per question, total at the end.

Use the syllabus context:
${extractedTexts.isEmpty ? "No uploaded files." : extractedTexts.join('\n---\n')}

Now generate the paper in clean, formatted text.
''';

    final paper = await _groq.chat(prompt,
        model: CHAT_MODEL, temperature: 0.3, maxTokens: 1800);

    final cleaned = cleanOutput(paper);

    setState(() => _isLoading = false);
    if (!mounted) return;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _FullScreenText(title: 'Generated Paper', text: cleaned),
    ));
  }

// _cleanOutput moved to groq_functions.dart as cleanOutput()


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Customizer')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header('Academic Context'),
              _buildField(() => TextFormField(
                    initialValue: _selectedUniversity,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'University'),
                  )),
              _buildField(() => _dropdown(
                    'Select Course',
                    _selectedCourse,
                    _courses,
                    (v) => setState(() {
                      _selectedCourse = v;
                      _selectedYear = null;
                      _selectedSubject = null;
                    }),
                  )),
              Row(
                children: [
                  Expanded(
                    child: _buildField(() => _dropdown(
                          'Select Year',
                          _selectedYear,
                          _years,
                          (v) => setState(() {
                            _selectedYear = v;
                            _selectedSubject = null;
                          }),
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(() => _dropdown(
                          'Select Subject',
                          _selectedSubject,
                          (_selectedCourse != null && _selectedYear != null)
                              ? _subjectsByCourse[_selectedCourse]![_selectedYear]!
                              : [],
                          (v) => setState(() => _selectedSubject = v),
                        )),
                  ),
                ],
              ),

              _header('Paper Details'),
              _buildField(() => TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Paper Title'),
                    validator: (v) => v!.isEmpty ? 'Enter title' : null,
                  )),
              Row(
                children: [
                  Expanded(
                    child: _buildField(() => TextFormField(
                          controller: _marksController,
                          decoration:
                              const InputDecoration(labelText: 'Total Marks'),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildField(() => TextFormField(
                          controller: _durationController,
                          decoration:
                              const InputDecoration(labelText: 'Duration (min)'),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        )),
                  ),
                ],
              ),

              _header('Source Material'),
              OutlinedButton.icon(
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Upload Documents'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _pickFiles,
              ),
              const SizedBox(height: 10),
              if (_uploadedFiles.isEmpty)
                const Text('No files uploaded yet.',
                    style: TextStyle(color: Colors.grey)),
              ..._uploadedFiles.map(
                (f) => Card(
                  margin: const EdgeInsets.only(top: 8),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: ListTile(
                    leading:
                        Icon(Icons.description_outlined, color: Theme.of(context).primaryColor),
                    title: Text(f.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          setState(() => _uploadedFiles.remove(f)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _handleGeneratePaper,
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.auto_awesome),
          label: Text(_isLoading ? 'Generating...' : 'Generate Paper'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            textStyle:
                Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
      );

  Widget _dropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Select one' : null,
    );
  }

  Widget _buildField(Widget Function() builder) =>
      Padding(padding: const EdgeInsets.only(bottom: 16), child: builder());
}

// ---------------- CLEAN PAPER VIEWER ----------------
class _FullScreenText extends StatelessWidget {
  final String title;
  final String text;
  const _FullScreenText({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final scroll = ScrollController();
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Scrollbar(
          controller: scroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scroll,
            padding: const EdgeInsets.all(18),
            child: SelectableText(
              text.isEmpty ? '(No content generated)' : text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// GroqService moved to groq_functions.dart
