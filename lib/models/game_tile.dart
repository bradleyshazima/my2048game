// lib/models/game_tile.dart
// This file defines the data model for a game tile,
// including properties needed for animation.

import 'package:flutter/material.dart'; // Required for @required or other annotations if used

class GameTile {
  final int id; // Unique ID for each tile instance, crucial for keys in lists
  int value;
  int row;
  int col;
  int previousRow; // For slide animation
  int previousCol; // For slide animation
  bool isNew; // For fade-in animation
  bool isMerged; // For scale-up/down animation

  GameTile({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.previousRow = -1, // Initialize with invalid positions
    this.previousCol = -1, // Will be set to actual position on first move
    this.isNew = false,
    this.isMerged = false,
  });

  // A copyWith method is useful for creating new instances with updated properties
  GameTile copyWith({
    int? id,
    int? value,
    int? row,
    int? col,
    int? previousRow,
    int? previousCol,
    bool? isNew,
    bool? isMerged,
  }) {
    return GameTile(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      previousRow: previousRow ?? this.previousRow,
      previousCol: previousCol ?? this.previousCol,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
    );
  }
}
