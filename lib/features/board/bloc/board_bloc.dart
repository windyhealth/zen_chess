import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zenchess/features/board/models/check_validator.dart';
import 'package:zenchess/features/board/models/piece_model.dart';

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
    on<CheckKingInCheckEvent>(_onCheckKingInCheck);
    on<MovingPieceEvent>(_onMovingPiece);
    on<SaveHistoryMoveEvent>(_onSaveHistoryMove);
    on<NextPlayerTurnEvent>(_onNextTurn);
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
    // Kiểm tra ván cờ đã kết thúc (checkmate)
    if (state.checkStatus == CheckStatus.blackInCheckMate ||
        state.checkStatus == CheckStatus.whiteInCheckMate) {
      return;
    }

    // Trường hợp đang xem lại nước đi cũ
    if (state.historyIndex != null &&
        state.historyIndex! < state.movesHistory.length - 1) return;

    final selectedSquare = event.selectedSquare;

    // Trường hợp chọn quân cờ
    if (state.fromSquare.isNull) {
      emit(
        state.copyWith(
          fromSquare: selectedSquare.copyWith(
            isNull: false,
          ),
        ),
      );
    } else if (state.toSquare.isNull) {
      emit(
        state.copyWith(
          toSquare: selectedSquare.copyWith(
            isNull: false,
          ),
        ),
      );
      // Kiểm tra và thực hiện nước đi
      Future.delayed(const Duration(milliseconds: 300), () {
        add(const MovingPieceEvent());
      });
    }
  }

  // Thực hiện nước đi
  void _onMovingPiece(MovingPieceEvent event, Emitter<BoardState> emit) {
    // Kiểm tra tồn tại
    if (state.fromSquare.isNull || state.toSquare.isNull) return;

    // Kiểm tra nước đi hợp lệ
    if (!_validatingMove(state.fromSquare, state.toSquare)) {
      emit(state.copyWith(toSquare: null));
      return;
    }

    BoardModel board = state.board;
    // Cập nhật fromSquare
    board = board.updateSquare(
      SquareModel(
        row: state.fromSquare.row,
        column: state.fromSquare.column,
        color: state.fromSquare.color,
        piece: null,
      ),
    );
    // Cập nhật toSquare
    board = board.updateSquare(SquareModel(
        row: state.toSquare.row,
        column: state.toSquare.column,
        color: state.toSquare.color,
        piece: state.fromSquare.piece!));

    // Nước đi
    MoveModel move = MoveModel(
      piece: state.fromSquare.piece!,
      pieceColor: state.fromSquare.piece!.color,
      from: state.fromSquare,
      to: state.toSquare,
    );

    // Cập nhật board
    emit(state.copyWith(
      board: board,
      fromSquare:
          const SquareModel(row: -1, column: -1, color: '', isNull: true),
      toSquare: const SquareModel(row: -1, column: -1, color: '', isNull: true),
      move: move,
    ));

    // Lưu lịch sử nước đi
    add(const SaveHistoryMoveEvent());
  }

  /// Lưu lịch sử nước đi
  void _onSaveHistoryMove(
      SaveHistoryMoveEvent event, Emitter<BoardState> emit) {
    if (state.move == null) return;
    emit(
      state.copyWith(
        movesHistory: List.from(state.movesHistory)..add(state.move!),
      ),
    );
    // Cập nhật trạng thái checking
    add(const CheckKingInCheckEvent());
  }

  // Kiểm tra nước đi có hợp lệ và thoát khỏi chiếu
  bool _validatingMove(SquareModel from, SquareModel to) {
    BoardModel board = state.board;

    if (!MoveValidator.instance
        .isValidMove(from, to, state.playerTurn, board)) {
      return false;
    }

    // Kiểm tra nước đi có thoát khỏi check
    if (CheckValidator.instance.isKingInCheck(
        state.playerTurn == PlayerTurn.white
            ? PieceColor.white
            : PieceColor.black,
        board)) {
      return false;
    }

    return true;
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
  }

  // Kiểm tra trạng thái check
  void _onCheckKingInCheck(
      CheckKingInCheckEvent event, Emitter<BoardState> emit) {
    // Check in check
    bool isInCheck = CheckValidator.instance.isKingInCheck(
        state.playerTurn == PlayerTurn.white
            ? PieceColor.black
            : PieceColor.white,
        state.board);
    if (isInCheck) {
      // Check in checkmate
      bool isInCheckMate = CheckValidator.instance.isCheckMate(
          state.playerTurn == PlayerTurn.white
              ? PieceColor.black
              : PieceColor.white,
          state.board);

      if (isInCheckMate) {
        emit(state.copyWith(
          checkStatus: state.playerTurn == PlayerTurn.white
              ? CheckStatus.blackInCheckMate
              : CheckStatus.whiteInCheckMate,
        ));
      } else {
        emit(state.copyWith(
          checkStatus: state.playerTurn == PlayerTurn.white
              ? CheckStatus.blackKingInCheck
              : CheckStatus.whiteKingInCheck,
        ));
      }
    } else {
      emit(
        state.copyWith(
          checkStatus: CheckStatus.none,
        ),
      );
    }

    // Next turn
    Future.delayed(const Duration(milliseconds: 300),
        () => add(const NextPlayerTurnEvent()));
  }

  /// Next turn
  void _onNextTurn(NextPlayerTurnEvent event, Emitter<BoardState> emit) {
    emit(
      NextPlayerTurnState(
        board: state.board,
        isLoaded: state.isLoaded,
        playerTurn: state.playerTurn == PlayerTurn.black
            ? PlayerTurn.white
            : PlayerTurn.black,
        movesHistory: state.movesHistory,
        historyIndex: state.historyIndex,
        checkStatus: state.checkStatus,
        fromSquare: state.fromSquare,
        toSquare: state.toSquare,
        move: state.move,
      ),
    );
  }
}
