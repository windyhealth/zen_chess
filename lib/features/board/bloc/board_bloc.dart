import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/board_model.dart';
import '../models/square_model.dart';
import '../models/move_validator.dart';

part 'board_event.dart';
part 'board_state.dart';

/// Quản lý logic và trạng thái của bàn cờ
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(const BoardState()) {
    on<LoadBoardEvent>(_onLoadBoard);
    on<SquareTappedEvent>(_onSquareTapped);
  }

  /// Xử lý sự kiện LoadBoardEvent
  void _onLoadBoard(LoadBoardEvent event, Emitter<BoardState> emit) {
    // Khởi tạo bàn cờ với trạng thái mặc định
    final board = BoardModel.initializeBoard();
    emit(state.copyWith(
      board: board,
      isLoaded: true,
    ));
  }

  /// Xử lý sự kiện SquareTappedEvent
  void _onSquareTapped(SquareTappedEvent event, Emitter<BoardState> emit) {
    final selectedSquare = event.selectedSquare;

    // Trường hợp chọn quân cờ
    if ((state.selectedSquare != null &&
            state.selectedSquare!.piece != null &&
            selectedSquare.hasPiece &&
            selectedSquare.piece!.color.name == state.playerTurn.name) ||
        ((state.selectedSquare == null ||
                state.selectedSquare?.piece == null) &&
            selectedSquare.hasPiece &&
            selectedSquare.piece!.color.name == state.playerTurn.name)) {
      emit(state.copyWith(selectedSquare: selectedSquare));
    } else if ((state.selectedSquare != null &&
            state.selectedSquare!.piece != null &&
            selectedSquare.hasPiece &&
            selectedSquare.piece!.color.name != state.playerTurn.name) ||
        (!selectedSquare.hasPiece &&
            state.selectedSquare != null &&
            state.selectedSquare!.piece != null)) {
      // Trường hợp đi quân cờ

      // Kiểm tra nước đi hợp lệ
      if (!MoveValidator.instance.isValidMove(
        state.selectedSquare!,
        event.selectedSquare,
        state.playerTurn,
        state.board,
      )) {
        return;
      }

      // Thực hiện nước đi
      BoardModel newBoard =
          _onMovingPiece(state.selectedSquare!, event.selectedSquare);

      emit(
        state.copyWith(
          board: newBoard,
          selectedSquare: null,
          playerTurn: state.playerTurn == PlayerTurn.white
              ? PlayerTurn.black
              : PlayerTurn.white,
        ),
      );
    }
  }

  // Thực hiện nước đi
  BoardModel _onMovingPiece(SquareModel fromSquare, SquareModel toSquare) {
    BoardModel board = state.board;
    // Cập nhật fromSquare
    board = board.updateSquare(
      SquareModel(
        row: fromSquare.row,
        column: fromSquare.column,
        color: fromSquare.color,
        piece: null,
      ),
    );
    // Cập nhật toSquare
    board = board.updateSquare(SquareModel(
        row: toSquare.row,
        column: toSquare.column,
        color: toSquare.color,
        piece: state.selectedSquare!.piece!));

    return board;
  }
}
