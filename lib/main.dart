import 'package:flutter/material.dart';
import 'dart:math'; // For random number generation

void main() {
  // The main function is the entry point of any Flutter application.
  // runApp takes a Widget and makes it the root of the widget tree.
  runApp(const MyApp());
}

// MyApp is a StatelessWidget because it doesn't need to manage any mutable state itself.
// It sets up the basic MaterialApp structure for the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title is used by the OS for task switcher, etc.
      title: '2048',
      // theme defines the visual properties of the app.
      theme: ThemeData(
        // Define a color scheme based on the provided colors
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            0xFFCCFF5F, // Primary color from your palette
            <int, Color>{
              50: Color(0xFFF9FFE6),
              100: Color(0xFFF2FFCC),
              200: Color(0xFFE6FF99),
              300: Color(0xFFDAFF66),
              400: Color(0xFFD3FF4D),
              500: Color(0xFFCCFF5F), // Your main green
              600: Color(0xFFB8E656),
              700: Color(0xFFA3CC4D),
              800: Color(0xFF8FB344),
              900: Color(0xFF7A993B),
            },
          ),
          // Use your dark color for background/surface
          backgroundColor: const Color(0xFF202020),
          cardColor: const Color(0xFF202020),
          // Set brightness to dark for better contrast with light green
          brightness: Brightness.dark,
        ),
        // Define text themes for Inter (descriptive) and Lexend Zetta (headings/buttons)
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'LexendZetta'),
          displayMedium: TextStyle(fontFamily: 'LexendZetta'),
          displaySmall: TextStyle(fontFamily: 'LexendZetta'),
          headlineLarge: TextStyle(fontFamily: 'LexendZetta'),
          headlineMedium: TextStyle(fontFamily: 'LexendZetta'),
          headlineSmall: TextStyle(fontFamily: 'LexendZetta'),
          titleLarge: TextStyle(fontFamily: 'LexendZetta'),
          titleMedium: TextStyle(fontFamily: 'LexendZetta'),
          titleSmall: TextStyle(fontFamily: 'LexendZetta'),
          labelLarge: TextStyle(fontFamily: 'LexendZetta'), // For buttons
          bodyLarge: TextStyle(fontFamily: 'Inter'),
          bodyMedium: TextStyle(fontFamily: 'Inter'),
          bodySmall: TextStyle(fontFamily: 'Inter'),
          labelMedium: TextStyle(fontFamily: 'Inter'),
          labelSmall: TextStyle(fontFamily: 'Inter'),
        ),
        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.transparent, // Transparent to show body gradient
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'LexendZetta', // Use Lexend Zetta for app bar title
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFBFBFB), // Light text on dark background
          ),
        ),
        // ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCCFF5F), // Button background color
            foregroundColor: const Color(0xFF202020), // Button text color
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Slightly more rounded
            ),
            elevation: 8, // More pronounced shadow
            textStyle: const TextStyle(
              fontFamily: 'LexendZetta', // Use Lexend Zetta for button text
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      // home defines the default route of the app. Here, it's our 2048 game.
      home: const Game2048(),
    );
  }
}

// Game2048 is a StatefulWidget because the game board and score will change over time.
// It needs to manage the state of the game.
class Game2048 extends StatefulWidget {
  const Game2048({super.key});

  @override
  State<Game2048> createState() => _Game2048State();
}

// The State class for Game2048. This is where the mutable state and game logic reside.
class _Game2048State extends State<Game2048> {
  static const int boardSize = 4; // The 4x4 grid for 2048
  List<List<int>> board = List.generate(
    boardSize,
    (_) => List.filled(boardSize, 0),
  ); // Initialize board with zeros
  int score = 0; // Current score
  bool gameOver = false; // Flag to check if game is over
  bool gameWon = false; // Flag to check if game is won (reached 2048)

  // New color palette based on FBFBFB, CCFF5F, 202020
  // Derived colors for a green/dark theme with gradients
  final Color primaryDark = const Color(0xFF202020);
  final Color primaryLight = const Color(0xFFFBFBFB);
  final Color accentGreen = const Color(0xFFCCFF5F);

  // Colors for tiles based on their value, adapted to the new theme.
  final Map<int, Color> tileColors = {
    0: const Color(0xFF2C2C2C), // Empty tile - slightly lighter dark
    2: const Color(0xFF3A3A3A), // Darker grey for low values
    4: const Color(0xFF4A4A4A),
    8: const Color(0xFF5A5A5A),
    16: const Color(0xFF6A6A6A),
    32: const Color(0xFF7A7A7A),
    64: const Color(0xFF8A8A8A),
    128: const Color(0xFF9A9A9A),
    256: const Color(0xFFB0B0B0),
    512: const Color(0xFFC0C0C0),
    1024: const Color(0xFFD0D0D0),
    2048: const Color(0xFFCCFF5F), // Reaching the accent green for 2048
  };

  // Text colors for tiles. Dark for small numbers, light for large numbers.
  final Map<int, Color> textColors = {
    0: const Color(0xFFFBFBFB), // Text on empty tile (not visible)
    2: const Color(0xFFFBFBFB), // Light text on dark background tiles
    4: const Color(0xFFFBFBFB),
    8: const Color(0xFFFBFBFB),
    16: const Color(0xFFFBFBFB),
    32: const Color(0xFFFBFBFB),
    64: const Color(0xFF202020), // Dark text on lighter background tiles
    128: const Color(0xFF202020),
    256: const Color(0xFF202020),
    512: const Color(0xFF202020),
    1024: const Color(0xFF202020),
    2048: const Color(0xFF202020), // Dark text on accent green tile
  };

  // Called when the State object is first created.
  // This is where you perform one-time initialization.
  @override
  void initState() {
    super.initState();
    _startGame(); // Start a new game when the widget initializes.
  }

  // Resets the game to its initial state.
  void _startGame() {
    setState(() {
      // Reset board to all zeros
      board = List.generate(boardSize, (_) => List.filled(boardSize, 0));
      score = 0;
      gameOver = false;
      gameWon = false;
      _addRandomTile(); // Add two initial tiles
      _addRandomTile();
    });
  }

  // Adds a new tile (2 or 4) to a random empty spot on the board.
  void _addRandomTile() {
    List<Point> emptyCells = []; // List to store coordinates of empty cells
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == 0) {
          emptyCells.add(Point(r, c)); // Add empty cell coordinates
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      // Pick a random empty cell
      final random = Random();
      final Point cell = emptyCells[random.nextInt(emptyCells.length)];
      // 90% chance of a 2, 10% chance of a 4
      final int newValue = random.nextDouble() < 0.9 ? 2 : 4;
      board[cell.x.toInt()][cell.y.toInt()] = newValue;

      // Check for win condition after adding a new tile
      if (newValue == 2048) {
        gameWon = true;
      }
    } else {
      // No empty cells, check for game over
      _checkGameOver();
    }
  }

  // Checks if the game is over (no more moves possible).
  void _checkGameOver() {
    if (gameWon) return; // If won, don't check for game over

    // Check for empty cells
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == 0) {
          gameOver = false; // Still empty cells, not game over
          return;
        }
      }
    }

    // Check for possible merges horizontally
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize - 1; c++) {
        if (board[r][c] != 0 && board[r][c] == board[r][c + 1]) {
          gameOver = false; // Possible horizontal merge
          return;
        }
      }
    }

    // Check for possible merges vertically
    for (int c = 0; c < boardSize; c++) {
      for (int r = 0; r < boardSize - 1; r++) {
        if (board[r][c] != 0 && board[r][c] == board[r + 1][c]) {
          gameOver = false; // Possible vertical merge
          return;
        }
      }
    }

    // If no empty cells and no possible merges, game is over
    setState(() {
      gameOver = true;
    });
  }

  // --- Game Logic for Swiping ---

  // Helper function to move tiles in a single row/column towards a direction.
  // `line` is the row/column to process.
  // `direction` is 1 for left/up, -1 for right/down.
  List<int> _moveLine(List<int> line, int direction) {
    List<int> newLine = line.where((val) => val != 0).toList(); // Remove zeros
    List<int> mergedLine = List.filled(boardSize, 0); // Resulting line

    // Merge tiles
    for (int i = 0; i < newLine.length - 1; i++) {
      if (newLine[i] != 0 && newLine[i] == newLine[i + 1]) {
        newLine[i] *= 2; // Double the value
        score += newLine[i]; // Add to score
        if (newLine[i] == 2048) gameWon = true; // Check for win
        newLine.removeAt(i + 1); // Remove the merged tile
      }
    }

    // Fill the merged line based on direction
    if (direction == 1) {
      // Left/Up
      for (int i = 0; i < newLine.length; i++) {
        mergedLine[i] = newLine[i];
      }
    } else {
      // Right/Down
      int offset = boardSize - newLine.length;
      for (int i = 0; i < newLine.length; i++) {
        mergedLine[i + offset] = newLine[i];
      }
    }
    return mergedLine;
  }

  // Handles a swipe gesture in a given direction.
  void _handleSwipe(SwipeDirection direction) {
    if (gameOver || gameWon) return; // Don't allow moves if game is over or won

    bool boardChanged = false; // Flag to track if any tiles moved or merged
    List<List<int>> newBoard = List.generate(
      boardSize,
      (_) => List.filled(boardSize, 0),
    );

    switch (direction) {
      case SwipeDirection.left:
        for (int r = 0; r < boardSize; r++) {
          List<int> originalRow = List.from(board[r]);
          List<int> movedRow = _moveLine(
            board[r],
            1,
          ); // Move left (direction 1)
          newBoard[r] = movedRow;
          if (!ListEquality.equals(originalRow, movedRow)) {
            boardChanged = true;
          }
        }
        break;
      case SwipeDirection.right:
        for (int r = 0; r < boardSize; r++) {
          List<int> originalRow = List.from(board[r]);
          List<int> movedRow = _moveLine(
            board[r],
            -1,
          ); // Move right (direction -1)
          newBoard[r] = movedRow;
          if (!ListEquality.equals(originalRow, movedRow)) {
            boardChanged = true;
          }
        }
        break;
      case SwipeDirection.up:
        for (int c = 0; c < boardSize; c++) {
          List<int> column = [];
          for (int r = 0; r < boardSize; r++) {
            column.add(board[r][c]);
          }
          List<int> originalColumn = List.from(column);
          List<int> movedColumn = _moveLine(column, 1); // Move up (direction 1)
          if (!ListEquality.equals(originalColumn, movedColumn)) {
            boardChanged = true;
          }
          for (int r = 0; r < boardSize; r++) {
            newBoard[r][c] = movedColumn[r];
          }
        }
        break;
      case SwipeDirection.down:
        for (int c = 0; c < boardSize; c++) {
          List<int> column = [];
          for (int r = 0; r < boardSize; r++) {
            column.add(board[r][c]);
          }
          List<int> originalColumn = List.from(column);
          List<int> movedColumn = _moveLine(
            column,
            -1,
          ); // Move down (direction -1)
          if (!ListEquality.equals(originalColumn, movedColumn)) {
            boardChanged = true;
          }
          for (int r = 0; r < boardSize; r++) {
            newBoard[r][c] = movedColumn[r];
          }
        }
        break;
    }

    // Update the board and add a new tile if changes occurred.
    if (boardChanged) {
      setState(() {
        board = newBoard;
        _addRandomTile();
        _checkGameOver(); // Check game over after each move
      });
    } else {
      // If no change, still check for game over (e.g., if board is full but no moves possible)
      _checkGameOver();
    }
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    // Scaffold provides a basic visual structure for Material Design apps.
    return Scaffold(
      // AppBar uses theme settings
      appBar: AppBar(
        title: const Text('2048 Game'), // Title style comes from theme
      ),
      // GestureDetector detects gestures like swipes.
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Detect vertical swipe
          if (details.primaryVelocity! < 0) {
            _handleSwipe(SwipeDirection.up);
          } else if (details.primaryVelocity! > 0) {
            _handleSwipe(SwipeDirection.down);
          }
        },
        onHorizontalDragEnd: (details) {
          // Detect horizontal swipe
          if (details.primaryVelocity! < 0) {
            _handleSwipe(SwipeDirection.left);
          } else if (details.primaryVelocity! > 0) {
            _handleSwipe(SwipeDirection.right);
          }
        },
        child: Container(
          // Diagonal gradient background for the entire body
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryDark, // Start dark
                Color.lerp(
                  primaryDark,
                  accentGreen,
                  0.3,
                )!, // Blend towards green
                accentGreen, // End with accent green
              ],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Score display
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: primaryDark.withOpacity(
                    0.8,
                  ), // Dark background for score
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Score: $score',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: primaryLight, // Light text for score
                    fontFamily: 'LexendZetta', // Use Lexend Zetta for score
                  ),
                ),
              ),
              // Game board grid
              AspectRatio(
                aspectRatio: 1, // Make the grid square
                child: Container(
                  padding: const EdgeInsets.all(
                    8.0,
                  ), // Padding inside the grid container
                  decoration: BoxDecoration(
                    color: primaryDark.withOpacity(
                      0.8,
                    ), // Dark background for the grid cells
                    borderRadius: BorderRadius.circular(
                      16,
                    ), // More rounded corners for the board
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: boardSize, // 4 columns
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                        ),
                    itemCount: boardSize * boardSize, // Total number of cells
                    itemBuilder: (context, index) {
                      // Calculate row and column from index
                      final int row = index ~/ boardSize;
                      final int col = index % boardSize;
                      final int tileValue = board[row][col];
                      // Return a TileWidget for each cell
                      return TileWidget(
                        value: tileValue,
                        color:
                            tileColors[tileValue] ??
                            const Color(0xFF2C2C2C), // Default empty tile color
                        textColor:
                            textColors[tileValue] ??
                            primaryLight, // Default text color
                      );
                    },
                  ),
                ),
              ),
              // Game Over / Game Won overlay
              if (gameOver || gameWon)
                _buildGameOverlay(
                  context,
                ), // Show overlay if game is over or won
              // New Game Button
              Padding(
                padding: const EdgeInsets.only(top: 30.0), // More space
                child: ElevatedButton(
                  onPressed:
                      _startGame, // Call _startGame when button is pressed
                  // Button style comes from theme
                  child: const Text(
                    'New Game',
                    // Text style comes from theme's labelLarge
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the game over or game won overlay.
  Widget _buildGameOverlay(BuildContext context) {
    String message;
    Color overlayColor;
    if (gameWon) {
      message = 'You Won!';
      overlayColor = accentGreen.withOpacity(0.8); // Green overlay for win
    } else {
      message = 'Game Over!';
      overlayColor = primaryDark.withOpacity(0.8); // Dark overlay for game over
    }

    return Positioned.fill(
      // Fills the available space
      child: Container(
        color: overlayColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: primaryLight, // Light text for overlay message
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryLight, // Light button for play again
                foregroundColor: primaryDark, // Dark text for play again button
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 22,
                ), // Use Lexend Zetta
              ),
              child: const Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// TileWidget is a StatelessWidget because a single tile's appearance depends only on its value.
// It doesn't manage any internal mutable state.
class TileWidget extends StatelessWidget {
  final int value;
  final Color color;
  final Color textColor;

  const TileWidget({
    super.key,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color, // Background color of the tile
        borderRadius: BorderRadius.circular(10.0), // Rounded corners for tiles
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        // Display the tile value, or nothing if it's 0 (empty).
        child: Text(
          value == 0 ? '' : '$value',
          style: TextStyle(
            fontSize: _getFontSize(value), // Dynamic font size based on value
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: value >= 1024
                ? 'LexendZetta'
                : 'Inter', // Lexend Zetta for high values, Inter for others
          ),
        ),
      ),
    );
  }

  // Helper to determine font size based on tile value for better readability.
  double _getFontSize(int value) {
    if (value >= 1024) {
      return 22.0; // Slightly smaller for Lexend Zetta to fit
    } else if (value >= 128) {
      return 26.0;
    } else if (value >= 16) {
      return 30.0;
    }
    return 34.0;
  }
}

// Enum to define swipe directions for better readability.
enum SwipeDirection { up, down, left, right }

// Helper class for comparing lists. Dart's List equality checks reference, not content.
class ListEquality {
  static bool equals<T>(List<T>? list1, List<T>? list2) {
    if (identical(list1, list2)) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] is List) {
        // Handle nested lists (for 2D board)
        if (!equals(list1[i] as List?, list2[i] as List?)) return false;
      } else if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
