import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superx/View/dashboard.dart';
import 'package:superx/View/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 2), () => _navigateUser());
  }

  void _navigateUser() async {
    // To prevent navigation if the widget is no longer in the tree
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check for the 'isLoggedIn' key, default to false if not found
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navigate to Dashboard and remove splash screen from stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // Navigate to Login and remove splash screen from stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive UI
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // This Expanded widget pushes the bottom line to the very bottom
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stack to overlay the circles
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Big outer circle
                        Container(
                          width: screenWidth * 0.5, // 50% of screen width
                          height: screenWidth * 0.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                        ),
                        // Small inner circle using the theme's primary color
                        Container(
                          width: screenWidth * 0.25, // 25% of screen width
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04), // 4% of screen height
                    // App Name
                    Text(
                      'QUARK',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        letterSpacing: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Aesthetic line at the bottom
              Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.09), // 5% from bottom
                height: 4,
                width: screenWidth * 0.75, // 30% of screen width
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}