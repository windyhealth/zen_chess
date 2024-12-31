import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/board_model.dart';
import '../models/square_model.dart';
import '../models/move_validator.dart';
import '../models/move_model.dart';

part 'board_event.dart';
part 'board_state.dart';

/// Quản lý logic và trạng thái của bàn cờ
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(const BoardState()) {
    on<LoadBoardEvent>(_onLoadBoard);
    on<SquareTappedEvent>(_onSquareTapped);
    on<MovingBackEvent>(_onMovingBack);
    on<MovingForwardEvent>(_onMovingForward);
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
    // Trường hợp đang xem lại nước đi cũ
    if (state.historyIndex != null &&
        state.historyIndex! < state.movesHistory.length - 1) return;

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

      // Lịch sử nước đi
      MoveModel move = MoveModel(
        piece: state.selectedSquare!.piece!,
        pieceColor: state.selectedSquare!.piece!.color,
        from: state.selectedSquare!,
        to: event.selectedSquare,
        capturedPiece: event.selectedSquare.piece,
      );

      emit(
        state.copyWith(
          board: newBoard,
          selectedSquare: null,
          playerTurn: state.playerTurn == PlayerTurn.white
              ? PlayerTurn.black
              : PlayerTurn.white,
          movesHistory: List.from(state.movesHistory)..add(move),
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

  // Xử lý sự kiện moveBackEvent
  void _onMovingBack(MovingBackEvent event, Emitter<BoardState> emit) {
    if (state.movesHistory.isEmpty) return;
    int historyIndex;
    if (state.historyIndex == null) {
      historyIndex = state.movesHistory.length - 1;
    } else {
      historyIndex = state.historyIndex!;
    }
    MoveModel lastMove = state.movesHistory[historyIndex];
    BoardModel board = state.board;
    // Khôi phục to
    board = board.updateSquare(
      SquareModel(
        row: lastMove.to.row,
        column: lastMove.to.column,
        color: lastMove.to.color,
        piece: lastMove.to.piece,
      ),
    );

    // Khôi phục from
    board = board.updateSquare(
      SquareModel(
        row: lastMove.from.row,
        column: lastMove.from.column,
        color: lastMove.from.color,
        piece: lastMove.from.piece,
      ),
    );

    emit(
      state.copyWith(
        board: board,
        historyIndex: historyIndex == 0 ? 0 : historyIndex - 1,
      ),
    );

    print('historyIndex = $historyIndex');
    print('historyIndex state = ${state.historyIndex}');
  }

  // Xử lý sự kiện MovingForwardEvent
  void _onMovingForward(MovingForwardEvent event, Emitter<BoardState> emit) {
    if (state.historyIndex == null) {
      return;
    }

    int historyIndex = state.historyIndex!;
    MoveModel nextMove = state.movesHistory[historyIndex];

    BoardModel board = state.board;

    // Cập nhật from
    board = board.updateSquare(SquareModel(
      row: nextMove.from.row,
      column: nextMove.from.column,
      color: nextMove.from.color,
      piece: null,
    ));

    // Cập nhật to
    board = board.updateSquare(SquareModel(
      row: nextMove.to.row,
      column: nextMove.to.column,
      color: nextMove.to.color,
      piece: nextMove.from.piece,
    ));

    emit(state.copyWith(
      board: board,
      historyIndex: historyIndex == state.movesHistory.length - 1
          ? historyIndex
          : historyIndex + 1,
    ));

    print('historyIndex = $historyIndex');
    print('historyIndex state = ${state.historyIndex}');
  }
}
