import 'package:zenchess/features/board/bloc/board_bloc.dart';

import 'board_model.dart';
import 'piece_model.dart';
import 'square_model.dart';

class MoveValidator {
  static MoveValidator instance = MoveValidator._privatedConstructor();
  MoveValidator._privatedConstructor();

  /// Kiểm tra xem nước đi có hợp lệ hay không
  bool isValidMove(SquareModel from, SquareModel to, PlayerTurn playerTurn) {
    // Kiểm tra trong from có quân cờ không
    if (!from.hasPiece) return false;

    // Kiểm tra có đi đúng lượt không
    if (!_isValidPlayerTurn(from.piece!, playerTurn)) return false;

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
}
