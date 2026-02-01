import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superx/Settings/theme_data.dart';
// import 'package:superx/View/about_us.dart'; // COMMENTED OUT
import 'package:superx/View/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:superx/View/voice_temp';
import 'package:superx/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Asynchronously load the theme from shared preferences
  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeStr = prefs.getString('theme');

    setState(() {
      if (themeStr == 'light') {
        _themeMode = ThemeMode.light;
      } else if (themeStr == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  void changeTheme(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = themeMode;
    });

    if (themeMode == ThemeMode.light) {
      await prefs.setString('theme', 'light');
    } else if (themeMode == ThemeMode.dark) {
      await prefs.setString('theme', 'dark');
    } else {
      await prefs.remove('theme');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quark',
      theme: QuarkTheme.lightTheme,
      darkTheme: QuarkTheme.darkTheme,
      // Use the _themeMode state variable here
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //  home: const VoiceAssistantView(),
      // home: const AboutUsPage(),
    );
  }
}

