// lib/views/chat/widgets/customized_chat_popup.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import file_picker
import 'package:superx/View/chat_screen.dart'; // Make sure path is correct

class CustomizedChatPopup extends StatefulWidget {
  const CustomizedChatPopup({super.key});

  @override
  State<CustomizedChatPopup> createState() => _CustomizedChatPopupState();
}

class _CustomizedChatPopupState extends State<CustomizedChatPopup> {
  String? _chatMode = 'Explanations';
  String? _selectedSubject;

  // --- NEW: State variable to hold uploaded files ---
  final List<PlatformFile> _uploadedFiles = [];

  // --- NEW: File picking logic ---
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        setState(() {
          _uploadedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking files: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customize Your Chat', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _buildDropdown('How should Quark respond?', _chatMode, ['Explanations', 'Answers Only', 'Learning Mode'], (val) => setState(() => _chatMode = val)),
          _buildDropdown('Subject', _selectedSubject, ['Pattern Recognition', 'Web Technology', 'Database Systems'], (val) => setState(() => _selectedSubject = val)),
          const SizedBox(height: 16),

          OutlinedButton.icon(
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Upload Documents (Optional)'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50), foregroundColor: Theme.of(context).primaryColor, side: BorderSide(color: Theme.of(context).primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            // --- UPDATED: Call the file picker ---
            onPressed: _pickFiles,
          ),
          const SizedBox(height: 8),

          // --- NEW: Display the list of uploaded files ---
          ..._uploadedFiles.map((file) => _buildUploadedFileTile(context, file)),
          
          const SizedBox(height: 24),
          ElevatedButton(
            child: const Text('Start Chat'),
            onPressed: () {
              // --- UPDATED: Pass the files along with other data ---
              final customData = {
                'mode': _chatMode,
                'subject': _selectedSubject,
                'files': _uploadedFiles.map((f) => f.name).toList(), // Pass file names
              };
              Navigator.pop(context); // Close the bottom sheet
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatScreen(mode: ChatMode.custom, customData: customData)));
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please make a selection' : null,
      ),
    );
  }

  // --- NEW: Helper to display an uploaded file tile ---
  Widget _buildUploadedFileTile(BuildContext context, PlatformFile file) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      elevation: 0,
      color: Theme.of(context).inputDecorationTheme.fillColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.description_outlined, color: Theme.of(context).primaryColor),
        title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB'),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () => setState(() => _uploadedFiles.remove(file)),
        ),
      ),
    );
  }
}