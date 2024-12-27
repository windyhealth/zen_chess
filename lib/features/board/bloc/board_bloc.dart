import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zenchess/features/board/models/piece_model.dart';

import '../models/board_model.dart';
import '../models/square_model.dart';

part 'board_event.dart';
part 'board_state.dart';

/// Quản lý logic và trạng thái của bàn cờ
class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(const BoardState()) {
    on<LoadBoardEvent>(_onLoadBoard);
    on<SquareTappedEvent>(_onSquareTapped);
    on<MovePieceEvent>(_onMovePiece);
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
    print(event.selectedSquare);
    final currentSquare = event.selectedSquare;

    if (state.selectedSquare != null) {
      // Thực hiện nước đi
      BoardModel board = state.board;
      // Cập nhật fromSquare
      board = board.updateSquare(
        SquareModel(
          row: state.selectedSquare!.row,
          column: state.selectedSquare!.column,
          color: state.selectedSquare!.color,
          piece: null,
        ),
      );
      // Cập nhật toSquare
      board = board.updateSquare(SquareModel(
          row: currentSquare.row,
          column: currentSquare.column,
          color: currentSquare.color,
          piece: state.selectedSquare!.piece!));

      emit(state.copyWith(
        board: board,
        selectedSquare: null,
      ));
    } else if (currentSquare.hasPiece) {
      // Chọn quân cờ
      emit(state.copyWith(selectedSquare: currentSquare));
      print('Đã chọn quân cờ ${currentSquare.piece?.type}');
    }
  }

  /// Xử lý sự kiện MovePieceEvent
  void _onMovePiece(MovePieceEvent event, Emitter<BoardState> emit) {}
}
