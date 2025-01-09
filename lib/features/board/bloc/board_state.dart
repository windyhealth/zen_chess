part of 'board_bloc.dart';

enum PlayerTurn { white, black }

enum CheckStatus {
  none,
  whiteKingInCheck,
  blackKingInCheck,
  whiteInCheckMate,
  blackInCheckMate
}

class BoardState extends Equatable {
  const BoardState({
    this.board = const BoardModel(squares: []),
    this.selectedSquare,
    this.isLoaded = false,
    this.playerTurn = PlayerTurn.white,
    this.movesHistory = const [],
    this.historyIndex,
    this.checkStatus,
    this.fromSquare = const SquareModel(
      row: -1,
      column: -1,
      color: '',
      isNull: true,
    ),
    this.toSquare = const SquareModel(
      row: -1,
      column: -1,
      color: '',
      isNull: true,
    ),
    this.move,
  });

  final BoardModel board;
  final bool isLoaded;
  final PlayerTurn playerTurn;
  final SquareModel? selectedSquare;
  final List<MoveModel> movesHistory;
  final int? historyIndex;
  final CheckStatus? checkStatus;
  final SquareModel fromSquare;
  final SquareModel toSquare;
  final MoveModel? move;

  @override
  List<Object?> get props => [
        board,
        isLoaded,
        selectedSquare,
        movesHistory,
        historyIndex,
        checkStatus,
        fromSquare,
        toSquare,
        move,
      ];

  BoardState copyWith({
    BoardModel? board,
    bool? isLoaded,
    SquareModel? selectedSquare,
    PlayerTurn? playerTurn,
    List<MoveModel>? movesHistory,
    int? historyIndex,
    CheckStatus? checkStatus,
    SquareModel? fromSquare,
    SquareModel? toSquare,
    MoveModel? move,
  }) {
    return BoardState(
      board: board ?? this.board,
      isLoaded: isLoaded ?? this.isLoaded,
      selectedSquare: selectedSquare,
      playerTurn: playerTurn ?? this.playerTurn,
      movesHistory: movesHistory ?? this.movesHistory,
      historyIndex: historyIndex ?? this.historyIndex,
      checkStatus: checkStatus ?? this.checkStatus,
      fromSquare: fromSquare ?? this.fromSquare,
      toSquare: toSquare ?? this.toSquare,
      move: move ?? this.move,
    );
  }
}

class NextPlayerTurnState extends BoardState {
  const NextPlayerTurnState({
    required super.board,
    required super.isLoaded,
    required super.playerTurn,
    required super.movesHistory,
    required super.historyIndex,
    required super.checkStatus,
    required super.fromSquare,
    required super.toSquare,
    required super.move,
  });
}
