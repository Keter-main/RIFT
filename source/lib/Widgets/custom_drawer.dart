// // lib/views/dashboard/widgets/custom_drawer.dart
// import 'package:flutter/material.dart';
// import 'package:superx/View/place(TEMP).dart';
// import 'package:superx/View/profile_page.dart';
// import 'package:superx/View/saved_chat_screen.dart';
// import 'package:superx/View/settings_page.dart';
// import 'package:superx/main.dart';

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const String username = "Keter";
//     const String email = "keter@quark.ai";
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;

//     // --- THIS IS THE FIX ---
//     // We define the header's background and text colors based on the theme.
//     final drawerHeaderColor = isLightTheme
//         ? Theme.of(context).primaryColor // Use theme color for light mode
//         : const Color.fromARGB(255, 4, 102, 134);      // Use a hardcoded deep blue for dark mode

//     final headerTextColor = isLightTheme
//         ? Theme.of(context).colorScheme.onPrimary // Use theme's onPrimary for light
//         : Colors.white;                         // Use plain white for dark for high contrast

//     return Drawer(
//       child: Column(
//         children: [
//           // 30% Header Section
//           SizedBox(
//             height: screenHeight * 0.3,
//             child: DrawerHeader(
//               padding: const EdgeInsets.all(20),
//               // Apply our conditional color here
//               decoration: BoxDecoration(color: drawerHeaderColor),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundImage: NetworkImage('https://images.unsplash.com/photo-1706997770544-049a30962ae6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cm90YXJ5JTIwZW5naW5lJTIwY2FyfGVufDB8fDB8fHww'),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Apply our conditional text color
//                           Text(username, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: headerTextColor)),
//                           Text(email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: headerTextColor.withOpacity(0.8))),
//                         ],
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           MyApp.of(context).changeTheme(isLightTheme ? ThemeMode.dark : ThemeMode.light);
//                         },
//                         icon: Icon(
//                           isLightTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
//                           // Apply our conditional icon color
//                           color: headerTextColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // 70% Menu Items Section
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 _buildDrawerItem(context, icon: Icons.person_outline, title: 'My Profile', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfilePage()))),
//                 _buildDrawerItem(context, icon: Icons.history, title: 'Prompt History', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaceholderScreen(title: 'Prompt History')))),
//                 _buildDrawerItem(context, icon: Icons.bookmark_border, title: 'Saved Chats', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedChatsScreen()))),
//                 _buildDrawerItem(context, icon: Icons.settings_outlined, title: 'Settings', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()))),
//                 const Divider(),
//                 _buildDrawerItem(context, icon: Icons.people_outline, title: 'Invite Friends', onTap: () {}),
//                 _buildDrawerItem(context, icon: Icons.star_outline, title: 'Quark Features', onTap: () {}),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper widget - no changes needed here
//   Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Theme.of(context).primaryColor),
//       title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
//       onTap: onTap,
//     );
//   }
// }