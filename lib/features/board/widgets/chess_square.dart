import 'dart:math';

import 'package:flutter/material.dart';
import '../models/square_model.dart';
import '../models/piece_model.dart';

/// Widget hiển thị một ô vuông trên bàn cờ
class ChessSquare extends StatelessWidget {
  final SquareModel square;
  final void Function()? onTap;

  const ChessSquare({
    super.key,
    required this.square,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: square.color == "white"
              ? const Color(0xFF769655)
              : const Color(0xFFEEEED2),
          border: Border.all(color: Colors.transparent),
        ),
        child: _buildPiece(),
      ),
    );
  }

  /// Hiển thị quân cờ nếu ô vuông chứa quân cờ
  Widget _buildPiece() {
    if (square.piece == null) {
      return const SizedBox
          .shrink(); // Trả về một widget rỗng nếu không có quân cờ
    }

    return Center(
      child: Image.asset(
        _getPieceImagePath(square.piece!),
        width: 40.0,
        height: 40.0,
        fit: BoxFit.contain,
      ),
    );
  }

  String _getPieceImagePath(PieceModel piece) {
    return "assets/pieces/${piece.color.name}_${piece.type.name}.png";
  }
}
