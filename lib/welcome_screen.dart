// lib/welcome_screen.dart
import 'package:flutter/material.dart';
// Import all specific game screens
import 'package:my_2048_game/game_screen_4x4.dart';
import 'package:my_2048_game/game_screen_5x5.dart';
import 'package:my_2048_game/game_screen_6x6.dart';
import 'package:my_2048_game/game_screen_8x8.dart'; // Import the new 8x8 game screen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  final List<Map<String, dynamic>> gameTypes = [
    {'size': 4, 'name': 'Classic', 'route': '/game_4x4'},
    {'size': 5, 'name': 'Large', 'route': '/game_5x5'},
    {'size': 6, 'name': 'Wide', 'route': '/game_6x6'},
    {'size': 8, 'name': 'Huge', 'route': '/game_8x8'}, // Added 8x8 game type
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = Theme.of(context).colorScheme.background;
    final Color primaryLight = Theme.of(context).colorScheme.onBackground;
    final Color accentGreen = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            // Optional: add action for the title
          },
          child: const Text(
            '2048',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryDark,
              Color.lerp(primaryDark, accentGreen, 0.3)!,
              accentGreen,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Text(
              '2048',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                itemCount: gameTypes.length,
                itemBuilder: (context, index) {
                  final gameType = gameTypes[index];
                  return Center(
                    child: SizedBox(
                      height: 200,
                      child: GameTypeCard(
                        boardSize: gameType['size'],
                        gameName: gameType['name'],
                        isActive: index == _currentPage,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 36, color: primaryLight),
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
                Text(
                  '${gameTypes[_currentPage]['size']}x${gameTypes[_currentPage]['size']}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 36,
                    color: primaryLight,
                  ),
                  onPressed: () {
                    if (_currentPage < gameTypes.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to the specific game screen based on the selected route
                final String selectedRoute = gameTypes[_currentPage]['route'];
                Navigator.pushNamed(context, selectedRoute);
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameTypeCard extends StatelessWidget {
  final int boardSize;
  final String gameName;
  final bool isActive;

  const GameTypeCard({
    super.key,
    required this.boardSize,
    required this.gameName,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = Theme.of(context).colorScheme.background;
    final Color accentGreen = Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: primaryDark.withOpacity(isActive ? 0.9 : 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? accentGreen : Colors.transparent,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.6 : 0.3),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardSize,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: boardSize * boardSize,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: primaryDark.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: accentGreen.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text(
            gameName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 32,
              color: accentGreen,
              shadows: [
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black.withOpacity(0.8),
                  offset: const Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
