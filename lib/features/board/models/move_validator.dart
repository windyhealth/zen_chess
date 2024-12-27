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
}
