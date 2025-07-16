🎲 2048 Flutter Game
A modern, responsive, and highly customizable implementation of the classic 2048 puzzle game built with Flutter. Experience the addictive gameplay with multiple board sizes and a sleek, dark-themed user interface.

✨ Features
Multiple Board Sizes: Play on classic 4x4, challenging 5x5, expansive 6x6, or intense 8x8 grids.

Intuitive Swipe Controls: Seamlessly move tiles with natural swipe gestures (up, down, left, right).

Dynamic Score Tracking: Keep track of your score as you merge tiles.

Game Over & Win Conditions: Clear indicators for when the game ends or when you achieve the 2048 tile.

Responsive Design: Enjoy a consistent and visually appealing experience across various mobile device sizes.

Custom Theming: A dark-mode inspired theme with vibrant green accents.

Clean Code Architecture: Game logic separated into distinct files for different board sizes, promoting maintainability and extensibility.

🚀 Tech Stack
Framework: Flutter (version as per your pubspec.yaml)

Language: Dart

Core Libraries:

package:flutter/material.dart for UI components.

dart:math for random number generation.

Font Families:

LexendZetta (for headings, titles, and prominent text)

Inter (for body text and descriptive labels)

🛠️ Installation & Setup (For Developers)
To get a local copy of the project up and running on your machine, follow these steps.

Prerequisites
Flutter SDK installed and configured.

A code editor (e.g., VS Code with Flutter extension, Android Studio).

A device (Android/iOS phone) or emulator/simulator to run the app.

Steps
Clone the repository:

git clone https://github.com/your-username/your-2048-game-repo.git
cd your-2048-game-repo

(Replace your-username/your-2048-game-repo.git with your actual repository URL)

Fetch dependencies:

flutter pub get

Run the application:

flutter run

This command will launch the app on your connected device or emulator.

🎮 How to Play
Start the Game: From the welcome screen, swipe through the game type cards (4x4, 5x5, 6x6, 8x8) and tap the "Start Game" button for your desired board size.

Move Tiles: Swipe your finger across the screen (up, down, left, or right) to move all tiles in that direction.

Merge Tiles: When two tiles with the same number touch, they merge into one tile with the sum of their values (e.g., two '2's merge into a '4').

New Tiles: A new '2' or '4' tile will appear in a random empty spot after each valid move.

Goal: Continue merging tiles to reach the coveted '2048' tile.

Game Over: The game ends when the board is full, and no more moves (merges or shifts) are possible.

New Game: Click the "New Game" button at any time to restart.

📂 Project Structure
The core game logic and UI are organized within the lib directory:

my_2048_game/
├── lib/
│   ├── main.dart             # Main application entry point and route definitions.
│   ├── welcome_screen.dart   # The initial screen for selecting game types.
│   ├── settings_screen.dart  # Placeholder for future settings (if implemented).
│   ├── game_screen_4x4.dart  # Game logic and UI for the 4x4 board.
│   ├── game_screen_5x5.dart  # Game logic and UI for the 5x5 board.
│   ├── game_screen_6x6.dart  # Game logic and UI for the 6x6 board.
│   └── game_screen_8x8.dart  # Game logic and UI for the 8x8 board.
├── pubspec.yaml              # Project dependencies and metadata.
└── README.md                 # This file.

🎨 Customization (For Developers)
Theming:

Colors are defined in main.dart and used throughout the app. Modify primaryDark, primaryLight, and accentGreen to change the overall color scheme.

Tile specific colors and text colors are mapped in each game_screen_X.dart file within the _GameScreenXState class.

Fonts:

Font families (LexendZetta, Inter) are set in main.dart's ThemeData. Ensure these fonts are correctly imported and declared in your pubspec.yaml under the fonts section if you wish to use custom font files.

Adding New Board Sizes:

Create a new game_screen_XxX.dart file (e.g., game_screen_7x7.dart).

Copy the content from an existing game_screen_X.dart file.

Update the static const int boardSize variable to the new size (e.g., 7).

Adjust the _getFontSize method in the TileWidget within the new file to ensure numbers fit well on the new grid density.

Import the new game_screen_XxX.dart file into main.dart.

Add a new route for /game_XxX in main.dart's routes map.

Update the gameTypes list in welcome_screen.dart to include the new game size and its corresponding route.

🤝 Contributing
Contributions are welcome! If you have suggestions for improvements, new features, or bug fixes, please feel free to:

Fork the repository.

Create a new branch (git checkout -b feature/AmazingFeature).

Make your changes.

Commit your changes (git commit -m 'Add some AmazingFeature').

Push to the branch (git push origin feature/AmazingFeature).

Open a Pull Request.

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
Inspired by the original 2048 game by Gabriele Cirulli.

Flutter community for excellent documentation and resources.

Google Fonts for Lexend Zetta and Inter font families.
