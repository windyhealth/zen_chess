part of 'board_bloc.dart';

enum PlayerTurn { white, black }

final class BoardState extends Equatable {
  const BoardState({
    this.board = const BoardModel(squares: []),
    this.selectedSquare,
    this.isLoaded = false,
    this.playerTurn = PlayerTurn.white,
    this.movesHistory = const [],
    this.historyIndex,
  });

  final BoardModel board;
  final bool isLoaded;
  final PlayerTurn playerTurn;
  final SquareModel? selectedSquare;
  final List<MoveModel> movesHistory;
  final int? historyIndex;

  @override
  List<Object?> get props =>
      [board, isLoaded, selectedSquare, movesHistory, historyIndex];

  BoardState copyWith({
    BoardModel? board,
    bool? isLoaded,
    SquareModel? selectedSquare,
    PlayerTurn? playerTurn,
    List<MoveModel>? movesHistory,
    int? historyIndex,
  }) {
    return BoardState(
      board: board ?? this.board,
      isLoaded: isLoaded ?? this.isLoaded,
      selectedSquare: selectedSquare,
      playerTurn: playerTurn ?? this.playerTurn,
      movesHistory: movesHistory ?? this.movesHistory,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }
}
