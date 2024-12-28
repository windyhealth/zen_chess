import 'dart:ui';

import 'package:zenchess/features/board/bloc/board_bloc.dart';

import 'board_model.dart';
import 'piece_model.dart';
import 'square_model.dart';

class MoveValidator {
  static MoveValidator instance = MoveValidator._privatedConstructor();
  MoveValidator._privatedConstructor();

  /// Kiểm tra xem nước đi có hợp lệ hay không
  bool isValidMove(SquareModel from, SquareModel to, PlayerTurn playerTurn,
      BoardModel board) {
    // Kiểm tra trong from có quân cờ không
    if (!from.hasPiece) return false;

    // Kiểm tra có đi đúng lượt không
    if (!_isValidPlayerTurn(from.piece!, playerTurn)) return false;

    // Kiểm tra logic cụ thể cho từng loại quân cờ
    switch (from.piece!.type) {
      case PieceType.pawn:
        return _isValidPawnMove(from, to, board);
      case PieceType.rook:
        return _isValidRookMove(from, to, board);
      case PieceType.bishop:
        return _isValidBishopMove(from, to, board);
      default:
        break;
    }

    return true;
  }

  // Kiểm tra có đi đúng lượt không
  bool _isValidPlayerTurn(PieceModel fromPiece, PlayerTurn playerTurn) {
    if (fromPiece.color.name == playerTurn.name) {
      return true;
    } else {
      return false;
    }
  }

  // Kiểm tra logic nước đi của quân tốt
  bool _isValidPawnMove(SquareModel from, SquareModel to, BoardModel board) {
    final int direction = from.piece!.color == PieceColor.white ? -1 : 1;

    final bool isStartingRow =
        (from.piece!.color == PieceColor.white && from.row == 6) ||
            (from.piece!.color == PieceColor.black && from.row == 1);

    // Nước đi thẳng 1 ô
    if (to.row == from.row + direction &&
        to.column == from.column &&
        !to.hasPiece) {
      return true;
    }

    // Nước đi thẳng 2 ô từ vị trí ban đàu
    if (isStartingRow &&
        to.row == from.row + 2 * direction &&
        to.column == from.column &&
        !to.hasPiece) {
      return true;
    }

    // Nước đi chéo để ăn quân
    if (to.row == from.row + direction &&
        (from.column - to.column).abs() == 1 &&
        to.hasPiece &&
        to.piece!.color != from.piece!.color) {
      return true;
    }

    // Nước đi bắt tốt qua đường - to do

    return false;
  }

  // Kiểm tra logic của quân xe
  bool _isValidRookMove(SquareModel from, SquareModel to, BoardModel board) {
    // Quân xe chỉ di chuyển theo hàng ngang hoặc hàng dọc
    if (from.row != to.row && from.column != to.column) {
      return false;
    }

    // Kiểm tra xem có quân nào cản đường không
    if (from.row == to.row) {
      // Di chuyển theo hàng ngang
      int start = from.column < to.column ? from.column + 1 : to.column + 1;
      int end = from.column < to.column ? to.column : from.column;
      for (int col = start; col < end; col++) {
        if (board.getSquare(from.row, col)?.hasPiece == true) {
          return false;
        }
      }
    } else if (from.column == to.column) {
      // Di chuyển theo hàng dọc
      int start = from.row < to.row ? from.row + 1 : to.row + 1;
      int end = from.row < to.row ? to.row : from.row;
      for (int row = start; row < end; row++) {
        if (board.getSquare(row, from.column)?.hasPiece == true) {
          return false;
        }
      }
    }

    return true;
  }

  // Kiểm tra logic của quân Tượng
  bool _isValidBishopMove(SquareModel from, SquareModel to, BoardModel board) {
    // Quân Tượng chỉ có thể di chuyển theo hàng chéo
    if ((from.row - to.row).abs() != (from.column - to.column).abs()) {
      return false;
    }

    // Xác định hướng di chuyển
    int rowDirection = (to.row - from.row) > 0 ? 1 : -1;
    int colDirection = (to.column - from.column) > 0 ? 1 : -1;

    // Kiểm ta từng ô trên đường chéo
    int steps = (from.row - to.row).abs();
    for (int i = 1; i < steps; i++) {
      int intermediateRow = from.row + i * rowDirection;
      int intermediateCol = from.column + i * colDirection;
      if (board.getSquare(intermediateRow, intermediateCol)?.hasPiece == true) {
        return false; // Có quân cản đường
      }
    }
    return true;
  }
}
