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
          color: square.color == "white" ? Colors.grey : Colors.green,
          border: Border.all(color: Colors.grey),
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
      child: Text(
        _pieceSymbol(square.piece!),
        style: TextStyle(
          color: square.piece!.color == PieceColor.white
              ? Colors.white
              : Colors.black,
          fontSize: 24.0,
        ),
      ),
    );
  }

  /// Lấy ký hiệu quân cờ từ model
  String _pieceSymbol(PieceModel piece) {
    switch (piece.type) {
      case PieceType.king:
        return piece.color == PieceColor.white ? '♔' : '♚';
      case PieceType.queen:
        return piece.color == PieceColor.white ? '♕' : '♛';
      case PieceType.rook:
        return piece.color == PieceColor.white ? '♖' : '♜';
      case PieceType.bishop:
        return piece.color == PieceColor.white ? '♗' : '♝';
      case PieceType.knight:
        return piece.color == PieceColor.white ? '♘' : '♞';
      case PieceType.pawn:
        return piece.color == PieceColor.white ? '♙' : '♟';
    }
  }
}
