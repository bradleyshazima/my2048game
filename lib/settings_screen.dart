// lib/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = Theme.of(context).colorScheme.background;
    final Color primaryLight = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryDark,
              Color.lerp(
                primaryDark,
                Theme.of(context).colorScheme.primary,
                0.3,
              )!,
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Settings Page',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'More options coming soon!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
