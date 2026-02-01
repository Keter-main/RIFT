// COMMENTED OUT - About US page
// This file has been commented out as per the consolidation refactoring
/*
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.95),
              theme.colorScheme.surface.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- TITLE ----------
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [accent, Colors.blueAccent],
                  ).createShader(bounds),
                  child: const Text(
                    'Quark',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Empowering Minds. Enhancing Learning. Evolving Intelligence.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // ---------- MISSION BOX ----------
                _glassBox(
                  context,
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, color: accent, size: 36),
                      const SizedBox(height: 16),
                      Text(
                        "Our Mentor",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                        Text(
                      "Prof. Shashi Bagal is an exceptional teacher and mentor who made Flutter truly come alive for us. "
                      "His clarity, depth, and passion for teaching inspire curiosity and creativity in every session. "
                      "With his guidance, we not only mastered Flutter's core concepts but learned to build meaningful, "
                      "high-quality applications with confidence and precision.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),


                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // ---------- TEAM SECTION ----------
                Text(
                  "Our Team",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        _teamCard(
                          context,
                          image: 'assets/images/sir.jpg',
                          name: 'Prof. Shashi Bagal',
                          role: 'Mentor',
                        ),
                        _teamCard(
                          context,
                          image: 'assets/images/siddhant.jpg',
                          name: 'Siddhant Kenjale',
                          role: 'Team Lead',
                        ),
                        _teamCard(
                          context,
                          image: 'assets/images/aryan.jpg',
                          name: 'Aryan Patil',
                          role: 'Team Member',
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // ---------- ABOUT QUARK ----------
                _glassBox(
                  context,
                  child: Column(
                    children: [
                      Icon(Icons.psychology_alt_rounded,
                          color: accent, size: 36),
                      const SizedBox(height: 16),
                      Text(
                        "About Quark",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Quark is a student-developed AI companion built for students — designed to revolutionize AI-based learning. "
                        "Born out of a passion for innovation, Quark bridges creativity and intelligence to make education smarter, faster, and deeply personalized. "
                        "Our mission is to redefine how SPPU students learn, explore, and excel through the power of intelligent assistance.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          height: 1.6,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ---------- FOOTER ----------
                Text(
                  "SuperX | Core2Web 2025",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Version 1.0.0",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- GLASS CARD ----------
  Widget _glassBox(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ---------- TEAM CARD ----------
  Widget _teamCard(BuildContext context,
      {required String image,
      required String name,
      required String role}) {
    final theme = Theme.of(context);
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              image,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 85,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person,
                      size: 45, color: Colors.white70),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
*/
