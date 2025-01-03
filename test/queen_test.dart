import 'package:flutter_test/flutter_test.dart';
import 'package:zenchess/features/board/bloc/board_bloc.dart';
import 'package:zenchess/features/board/models/board_model.dart';
import 'package:zenchess/features/board/models/move_validator.dart';
import 'package:zenchess/features/board/models/piece_model.dart';
import 'package:zenchess/features/board/models/square_model.dart';

void main() {
  late BoardModel board;
  late MoveValidator moveValidator;

  setUp(() {
    moveValidator = MoveValidator.instance;
    board = BoardModel.initializeBoard();
  });

  test('', () {
    SquareModel from = board.getSquare(5, 6)!;
    SquareModel to = board.getSquare(6, 5)!;

    board = board.updateSquare(from.copyWith(
        piece: PieceModel(
            type: PieceType.queen,
            color: PieceColor.black,
            position: from.position)));

    board = board.updateSquare(to.copyWith(
        piece: PieceModel(
            type: PieceType.king,
            color: PieceColor.white,
            position: to.position)));

    expect(moveValidator.isValidMove(from, to, PlayerTurn.black, board), true);
  });
}
