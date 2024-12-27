import 'package:flutter/material.dart';
import '../models/piece_model.dart';

/// Widget hiển thị một quân cờ trên bàn cờ
class ChessPiece extends StatelessWidget {
  final PieceModel piece;
  final double size; // Kích thước của quân cờ

  const ChessPiece({
    super.key,
    required this.piece,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: piece.color == PieceColor.white ? Colors.white : Colors.black,
      ),
      child: Center(
        child: Text(
          _getPieceSymbol(piece.type),
          style: TextStyle(
            color:
                piece.color == PieceColor.white ? Colors.black : Colors.white,
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Trả về ký hiệu đại diện cho loại quân cờ
  String _getPieceSymbol(PieceType type) {
    switch (type) {
      case PieceType.king:
        return 'K';
      case PieceType.queen:
        return 'Q';
      case PieceType.rook:
        return 'R';
      case PieceType.bishop:
        return 'B';
      case PieceType.knight:
        return 'N';
      case PieceType.pawn:
        return 'P';
    }
  }
}
