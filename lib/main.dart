// lib/main.dart
import 'package:flutter/material.dart';
import 'package:my_2048_game/welcome_screen.dart'; // Import the welcome screen
import 'package:my_2048_game/settings_screen.dart'; // Import the settings screen

// Import the new specific game screens
import 'package:my_2048_game/game_screen_4x4.dart';
import 'package:my_2048_game/game_screen_5x5.dart';
import 'package:my_2048_game/game_screen_6x6.dart';
import 'package:my_2048_game/game_screen_8x8.dart'; // New import for 8x8 game

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define your core colors
    final Color primaryDark = const Color(0xFF202020);
    final Color primaryLight = const Color(0xFFFBFBFB);
    final Color accentGreen = const Color(0xFFCCFF5F);

    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            accentGreen.value, // Use accentGreen as the primary swatch base
            <int, Color>{
              50: Color(0xFFF9FFE6),
              100: Color(0xFFF2FFCC),
              200: Color(0xFFE6FF99),
              300: Color(0xFFDAFF66),
              400: Color(0xFFD3FF4D),
              500: accentGreen, // Your main green
              600: Color(0xFFB8E656),
              700: Color(0xFFA3CC4D),
              800: Color(0xFF8FB344),
              900: Color(0xFF7A993B),
            },
          ),
          backgroundColor: primaryDark,
          cardColor: primaryDark,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          // Lexend Zetta for headings, titles, and buttons
          displayLarge: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          displayMedium: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          displaySmall: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          titleLarge: TextStyle(fontFamily: 'LexendZetta', color: primaryLight),
          titleMedium: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryLight,
          ),
          titleSmall: TextStyle(fontFamily: 'LexendZetta', color: primaryLight),
          labelLarge: TextStyle(
            fontFamily: 'LexendZetta',
            color: primaryDark,
          ), // For buttons
          // Inter for body text and descriptive labels
          bodyLarge: TextStyle(fontFamily: 'Inter', color: primaryLight),
          bodyMedium: TextStyle(fontFamily: 'Inter', color: primaryLight),
          bodySmall: TextStyle(fontFamily: 'Inter', color: primaryLight),
          labelMedium: TextStyle(fontFamily: 'Inter', color: primaryLight),
          labelSmall: TextStyle(fontFamily: 'Inter', color: primaryLight),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'LexendZetta',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryLight,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentGreen,
            foregroundColor: primaryDark,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            textStyle: const TextStyle(
              fontFamily: 'LexendZetta',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/game_4x4': (context) => const GameScreen4x4(),
        '/game_5x5': (context) => const GameScreen5x5(),
        '/game_6x6': (context) => const GameScreen6x6(),
        '/game_8x8': (context) => const GameScreen8x8(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        // This part is for any dynamic routes you might add later that need arguments.
        // For now, our specific game screens don't need arguments passed this way.
        return null;
      },
    );
  }
}
