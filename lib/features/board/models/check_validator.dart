import '../bloc/board_bloc.dart';
import 'board_model.dart';
import 'piece_model.dart';
import 'square_model.dart';
import 'move_validator.dart';

class CheckValidator {
  static CheckValidator instance = CheckValidator._privateConstructor();
  CheckValidator._privateConstructor();

  // Kiểm tra vua có đang bị chiếu không
  bool isKingInCheck(PieceColor kingColor, BoardModel board) {
    SquareModel? kingSquare;

    // Tìm vị trí vua
    for (var row in board.squares) {
      for (var square in row) {
        if (square.piece?.type == PieceType.king &&
            square.piece?.color == kingColor) {
          kingSquare = square;
        }
      }
    }

    if (kingSquare == null) return false;

    // Kiểm tra các nước đi của đối phương
    for (var row in board.squares) {
      for (var square in row) {
        if (square.piece != null &&
            square.piece!.color != kingColor &&
            MoveValidator.instance.isValidMove(
                square,
                kingSquare,
                kingColor == PieceColor.white
                    ? PlayerTurn.black
                    : PlayerTurn.white,
                board)) {
          return true;
        }
      }
    }

    return false;
  }

  // Kiểm tra chiếu bí
  bool isCheckMate(PieceColor kingColor, BoardModel board) {
    if (!isKingInCheck(kingColor, board)) return false;

    // Kiểm tra tất cả các nước đi của vua và đồng minh
    for (var row in board.squares) {
      for (var square in row) {
        if (square.piece != null && square.piece!.color == kingColor) {
          // Giả lập tất các nước đi hợp lệ và kiểm tra vẫn còn bị chiếu hay không
          for (var targetRow in board.squares) {
            for (var targetSquare in targetRow) {
              if (MoveValidator.instance.isValidMove(
                  square,
                  targetSquare,
                  kingColor == PieceColor.white
                      ? PlayerTurn.white
                      : PlayerTurn.black,
                  board)) {
                // Giả lập nước đi
                BoardModel simulatedBoard =
                    board.updateSquare(square.copyWith(piece: null));

                simulatedBoard = simulatedBoard
                    .updateSquare(targetSquare.copyWith(piece: square.piece));

                // Kiểm tra vua đã thoát chiếu chưa
                if (isKingInCheck(kingColor, simulatedBoard) == false) {
                  return false;
                }
              }
            }
          }
        }
      }
    }

    return true;
  }
}
