// lib/game_screen_8x8.dart
import 'package:flutter/material.dart';
import 'dart:math'; // For random number generation

// GameScreen8x8 is a StatefulWidget to manage the 8x8 game board and score.
class GameScreen8x8 extends StatefulWidget {
  const GameScreen8x8({super.key});

  @override
  State<GameScreen8x8> createState() => _GameScreen8x8State();
}

// The State class for GameScreen8x8. This is where the mutable state and game logic reside.
class _GameScreen8x8State extends State<GameScreen8x8> {
  static const int boardSize =
      8; // The 8x8 grid for 2048, hardcoded for this screen
  List<List<int>> board = List.generate(
    boardSize,
    (_) => List.filled(boardSize, 0),
  ); // Initialize board with zeros
  int score = 0; // Current score
  bool gameOver = false; // Flag to check if game is over
  bool gameWon = false; // Flag to check if game is won (reached 2048)

  // New color palette based on FBFBFB, CCFF5F, 202020
  final Color primaryDark = const Color(0xFF202020);
  final Color primaryLight = const Color(0xFFFBFBFB);
  final Color accentGreen = const Color(0xFFCCFF5F);

  // Colors for tiles based on their value, adapted to the new theme.
  final Map<int, Color> tileColors = {
    0: const Color(0xFF2C2C2C), // Empty tile - slightly lighter dark
    2: const Color(0xFFEEE4DA), // Light background for 2
    4: const Color(0xFFEDE0C8), // Slightly darker light background for 4
    8: const Color(0xFFF2B179), // Orange-ish for 8
    16: const Color(0xFFF59563), // More orange for 16
    32: const Color(0xFFF67C5F), // Red-orange for 32
    64: const Color(0xFFF65E3B), // Red for 64
    128: const Color(0xFFEDCF72), // Light yellow for 128
    256: const Color(0xFFEDCC61), // Yellow for 256
    512: const Color(0xFFEDC850), // Darker yellow for 512
    1024: const Color(0xFFEDC53F), // Gold for 1024
    2048: const Color(0xFFCCFF5F), // Your accent green for 2048
  };

  // Text colors for tiles. Dark for small numbers, light for large numbers.
  final Map<int, Color> textColors = {
    0: const Color(0xFFFBFBFB), // Text on empty tile (not visible)
    2: const Color(0xFF776E65), // Dark text for 2
    4: const Color(0xFF776E65), // Dark text for 4
    8: const Color(0xFFF9F6F2), // Light text for 8
    16: const Color(0xFFF9F6F2),
    32: const Color(0xFFF9F6F2),
    64: const Color(0xFFF9F6F2),
    128: const Color(0xFFF9F6F2),
    256: const Color(0xFFF9F6F2),
    512: const Color(0xFFF9F6F2),
    1024: const Color(0xFFF9F6F2),
    2048: const Color(0xFF202020), // Dark text on accent green tile
  };

  // Called when the State object is first created.
  @override
  void initState() {
    super.initState();
    _startGame(); // Start a new game when the widget initializes.
  }

  // Resets the game to its initial state.
  void _startGame() {
    setState(() {
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
    List<Point> emptyCells = [];
    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == 0) {
          emptyCells.add(Point(r, c));
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      final random = Random();
      final Point cell = emptyCells[random.nextInt(emptyCells.length)];
      final int newValue = random.nextDouble() < 0.9 ? 2 : 4;
      board[cell.x.toInt()][cell.y.toInt()] = newValue;

      if (newValue == 2048) {
        gameWon = true;
      }
    } else {
      _checkGameOver();
    }
  }

  // Checks if the game is over (no more moves possible).
  void _checkGameOver() {
    if (gameWon) return;

    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize; c++) {
        if (board[r][c] == 0) {
          gameOver = false;
          return;
        }
      }
    }

    for (int r = 0; r < boardSize; r++) {
      for (int c = 0; c < boardSize - 1; c++) {
        if (board[r][c] != 0 && board[r][c] == board[r][c + 1]) {
          gameOver = false;
          return;
        }
      }
    }

    for (int c = 0; c < boardSize; c++) {
      for (int r = 0; r < boardSize - 1; r++) {
        if (board[r][c] != 0 && board[r][c] == board[r + 1][c]) {
          gameOver = false;
          return;
        }
      }
    }

    setState(() {
      gameOver = true;
    });
  }

  // Helper function to move tiles in a single row/column towards a direction.
  List<int> _moveLine(List<int> line, int direction) {
    List<int> newLine = line.where((val) => val != 0).toList();
    List<int> mergedLine = List.filled(boardSize, 0);

    for (int i = 0; i < newLine.length - 1; i++) {
      if (newLine[i] != 0 && newLine[i] == newLine[i + 1]) {
        newLine[i] *= 2;
        score += newLine[i];
        if (newLine[i] == 2048) gameWon = true;
        newLine.removeAt(i + 1);
      }
    }

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
    if (gameOver || gameWon) return;

    bool boardChanged = false;
    List<List<int>> newBoard = List.generate(
      boardSize,
      (_) => List.filled(boardSize, 0),
    );

    switch (direction) {
      case SwipeDirection.left:
        for (int r = 0; r < boardSize; r++) {
          List<int> originalRow = List.from(board[r]);
          List<int> movedRow = _moveLine(board[r], 1);
          newBoard[r] = movedRow;
          if (!ListEquality.equals(originalRow, movedRow)) {
            boardChanged = true;
          }
        }
        break;
      case SwipeDirection.right:
        for (int r = 0; r < boardSize; r++) {
          List<int> originalRow = List.from(board[r]);
          List<int> movedRow = _moveLine(board[r], -1);
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
          List<int> movedColumn = _moveLine(originalColumn, 1);
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
          List<int> movedColumn = _moveLine(originalColumn, -1);
          if (!ListEquality.equals(originalColumn, movedColumn)) {
            boardChanged = true;
          }
          for (int r = 0; r < boardSize; r++) {
            newBoard[r][c] = movedColumn[r];
          }
        }
        break;
    }

    if (boardChanged) {
      setState(() {
        board = newBoard;
        _addRandomTile();
        _checkGameOver();
      });
    } else {
      _checkGameOver();
    }
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = 16.0;
    final double tileSpacing = 2.0;
    final double gridSize = screenWidth - (padding * 2);
    final double actualTileSize =
        (gridSize - (boardSize + 1) * tileSpacing) / boardSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('8x8'), // Specific title for 8x8
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onPanEnd: (details) {
          final double primaryVelocity = details.velocity.pixelsPerSecond.dy;
          final double secondaryVelocity = details.velocity.pixelsPerSecond.dx;

          if (primaryVelocity.abs() > secondaryVelocity.abs()) {
            if (primaryVelocity < 0) {
              _handleSwipe(SwipeDirection.up);
            } else if (primaryVelocity > 0) {
              _handleSwipe(SwipeDirection.down);
            }
          } else {
            if (secondaryVelocity < 0) {
              _handleSwipe(SwipeDirection.left);
            } else if (secondaryVelocity > 0) {
              _handleSwipe(SwipeDirection.right);
            }
          }
        },
        child: Container(
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
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: primaryDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
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
                    color: primaryLight,
                    fontFamily: 'LexendZetta',
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: EdgeInsets.all(tileSpacing),
                  decoration: BoxDecoration(
                    color: primaryDark.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
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
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: boardSize,
                      crossAxisSpacing: tileSpacing,
                      mainAxisSpacing: tileSpacing,
                    ),
                    itemCount: boardSize * boardSize,
                    itemBuilder: (context, index) {
                      final int row = index ~/ boardSize;
                      final int col = index % boardSize;
                      final int tileValue = board[row][col];
                      return TileWidget(
                        value: tileValue,
                        color: tileColors[tileValue] ?? const Color(0xFF2C2C2C),
                        textColor: textColors[tileValue] ?? primaryLight,
                      );
                    },
                  ),
                ),
              ),
              if (gameOver || gameWon) _buildGameOverlay(context),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('New Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverlay(BuildContext context) {
    String message;
    Color overlayColor;
    if (gameWon) {
      message = 'You Won!';
      overlayColor = accentGreen.withOpacity(0.8);
    } else {
      message = 'Game Over!';
      overlayColor = primaryDark.withOpacity(0.8);
    }

    return Positioned.fill(
      child: Container(
        color: overlayColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: primaryLight,
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
                backgroundColor: primaryLight,
                foregroundColor: primaryDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontSize: 22),
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
        color: color,
        borderRadius: BorderRadius.circular(10.0),
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
        child: Text(
          value == 0 ? '' : '$value',
          style: TextStyle(
            fontSize: _getFontSize(value),
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: value >= 1024 ? 'LexendZetta' : 'Inter',
          ),
        ),
      ),
    );
  }

  // Helper to determine font size based on tile value for better readability.
  double _getFontSize(int value) {
    if (value >= 1024) {
      // For 1024 and higher, smaller font
      return 18.0;
    } else if (value >= 128) {
      return 22.0;
    } else if (value >= 16) {
      return 26.0;
    }
    return 30.0; // Default for 2, 4, 8
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
        if (!equals(list1[i] as List?, list2[i] as List?)) return false;
      } else if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
}
