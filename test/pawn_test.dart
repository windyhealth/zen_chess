import 'package:flutter/widgets.dart';
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

  // test('Pawn moves forward 1 step', () {
  //   SquareModel from = board.getSquare(6, 0)!;
  //   SquareModel to = board.getSquare(5, 0)!;

  //   expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), true);
  // });

  // test("Pawn tries to capture forward invalid", () {
  //   SquareModel from = board.getSquare(6, 0)!;
  //   SquareModel to = board.getSquare(5, 0)!;

  //   board = board.updateSquare(
  //     to.copyWith(
  //       piece: PieceModel(
  //         type: PieceType.knight,
  //         color: PieceColor.black,
  //         position: to.position,
  //       ),
  //     ),
  //   );

  //   expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), false);
  // });

  // test("Tốt đi thẳng 2 step ở ô khởi đầu", () {
  //   SquareModel from = board.getSquare(6, 0)!;
  //   SquareModel to = board.getSquare(4, 0)!;

  //   expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), true);
  // });

  // test("Tốt đi thẳng 2 step ở ô không phải khởi đầu", () {
  //   SquareModel from = board.getSquare(5, 0)!;
  //   SquareModel to = board.getSquare(3, 0)!;

  //   expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), false);
  // });

  // test("Tốt đi chéo 1 ô ăn quân", () {
  //   SquareModel from = board.getSquare(5, 0)!;
  //   SquareModel to = board.getSquare(4, 1)!;

  //   board = board.updateSquare(from.copyWith(
  //       piece: PieceModel(
  //           type: PieceType.pawn,
  //           color: PieceColor.white,
  //           position: from.position)));

  //   board = board.updateSquare(to.copyWith(
  //       piece: PieceModel(
  //           type: PieceType.knight,
  //           color: PieceColor.black,
  //           position: to.position)));

  //   expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), true);
  // });

  test("Tốt đi chéo 1 ô ăn quân (nhưng không có quân)", () {
    SquareModel from = board.getSquare(5, 0)!;
    SquareModel to = board.getSquare(4, 1)!;

    board = board.updateSquare(from.copyWith(
        piece: PieceModel(
            type: PieceType.pawn,
            color: PieceColor.white,
            position: from.position)));

    // board = board.updateSquare(to.copyWith(
    //     piece: PieceModel(
    //         type: PieceType.knight,
    //         color: PieceColor.black,
    //         position: to.position)));

    expect(moveValidator.isValidMove(from, to, PlayerTurn.white, board), false);
  });
}
