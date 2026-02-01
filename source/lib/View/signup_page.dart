// lib/views/auth/signup_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superx/Controller/auth_controller.dart';
import 'package:superx/View/login_screen.dart'; // Make sure this import path is correct

enum AcademicStatus { student, passout }

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _yearController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  // State variables
  String? _selectedDegree;
  final List<String> _degrees = [
    'B.Tech', 'B.Sc', 'B.A.', 'B.Com', 'Law (LLB)', 'Diploma',
    'M.Tech', 'M.Sc', 'MBA', 'PhD', 'Other'
  ];
  DateTime? _selectedDate;
  File? _profileImage;
  bool _isLoading = false;
  AcademicStatus _status = AcademicStatus.student;

  // <- Fixed: actual instance of AuthController
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _usernameController.dispose();
    _dobController.dispose();
    _yearController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Photo Library'), onTap: () => _pickImage(ImageSource.gallery)),
            ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () => _pickImage(ImageSource.camera)),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Minimal: save to SharedPreferences (only this helper added)
  Future<void> _saveToSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _usernameController.text.trim());
      await prefs.setString('dob', _dobController.text.trim());
      await prefs.setString('highest_degree', _selectedDegree ?? '');
      await prefs.setBool('isStudent', _status == AcademicStatus.student);
      await prefs.setString('academic_year',
          _status == AcademicStatus.student ? _yearController.text.trim() : '');
    } catch (e) {
      // Do not interrupt user flow; just log the error
      debugPrint('SharedPreferences save error: $e');
    }
  }

  void _handleSignUp() async {
    // Ensure form validators are satisfied
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.'))
      );
      return;
    }

    // Check date and degree selection
    if (_selectedDate == null || _selectedDegree == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.'))
      );
      return;
    }

    // Additional guard: confirm passwords match (validators already handle this)
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.'))
      );
      return;
    }

    setState(() => _isLoading = true);

    String res = await _authController.signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      username: _usernameController.text.trim(),
      dateOfBirth: _selectedDate!,
      currentEducation: _selectedDegree!,
      isStudent: _status == AcademicStatus.student,
      academicYear: _status == AcademicStatus.student ? _yearController.text.trim() : null,
      profileImage: _profileImage,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (res == "success") {
      // Fire-and-forget save to SharedPreferences (do NOT await)
      _saveToSharedPreferences();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully! Please sign in.'))
      );
      // Go to login screen (replace current)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    final isLastStep = _currentStep == 2;
                    if (isLastStep) {
                      if (_formKey.currentState!.validate()) {
                        _handleSignUp();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fix the errors in the form.'))
                        );
                      }
                    } else {
                      setState(() => _currentStep += 1);
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    }
                  },
                  controlsBuilder: (context, details) {
                    return _isLoading
                        ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator()))
                        : Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 12.0,
                              runSpacing: 12.0,
                              children: <Widget>[
                                TextButton(onPressed: details.onStepCancel, child: const Text('BACK')),
                                ElevatedButton(onPressed: details.onStepContinue, child: Text(_currentStep == 2 ? 'CREATE ACCOUNT' : 'CONTINUE')),
                              ],
                            ),
                          );
                  },
                  steps: [
                    Step(
                      title: const Text('Personal Details'),
                      isActive: _currentStep >= 0,
                      content: Column(children: [
                        InkWell(
                          onTap: _showImagePicker,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                            child: _profileImage == null ? Icon(Icons.add_a_photo_outlined, color: Theme.of(context).primaryColor, size: 40) : null,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _usernameController,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Please enter a username' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _dobController,
                          decoration: const InputDecoration(labelText: 'Date of Birth', suffixIcon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          validator: (value) => (value == null || value.isEmpty) ? 'Please select your date of birth' : null,
                        ),
                      ]),
                    ),
                    Step(
                      title: const Text('Academic Info'),
                      isActive: _currentStep >= 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            value: _selectedDegree,
                            decoration: const InputDecoration(labelText: 'Highest Degree'),
                            items: _degrees.map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newValue) => setState(() => _selectedDegree = newValue),
                            validator: (value) => value == null ? 'Please select your degree' : null,
                          ),
                          const SizedBox(height: 16),
                          Text('Status', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => setState(() => _status = AcademicStatus.student),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _status == AcademicStatus.student ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                                    foregroundColor: _status == AcademicStatus.student ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                                    side: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  child: const Text('Student'),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => setState(() => _status = AcademicStatus.passout),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _status == AcademicStatus.passout ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.surface,
                                    foregroundColor: _status == AcademicStatus.passout ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).textTheme.bodyLarge?.color,
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
                                    side: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  child: const Text('Passout'),
                                ),
                              ),
                            ],
                          ),

                          if (_status == AcademicStatus.student)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: _yearController,
                                decoration: const InputDecoration(labelText: 'Academic Year (e.g., 3rd Year)'),
                                validator: (value) => _status == AcademicStatus.student && (value == null || value.isEmpty) ? 'Please enter your academic year' : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Account Security'),
                      isActive: _currentStep >= 2,
                      content: Column(children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) => (value == null || !value.contains('@')) ? 'Please enter a valid email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Password'),
                          validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters long' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Confirm Password'),
                          validator: (value) => (value != _passwordController.text) ? 'Passwords do not match' : null,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
