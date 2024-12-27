part of 'board_bloc.dart';

enum PlayerTurn { white, black }

final class BoardState extends Equatable {
  const BoardState({
    this.board = const BoardModel(squares: []),
    this.selectedSquare,
    this.isLoaded = false,
    this.playerTurn = PlayerTurn.white,
  });

  final BoardModel board;
  final bool isLoaded;
  final PlayerTurn playerTurn;
  final SquareModel? selectedSquare;

  @override
  List<Object?> get props => [board, isLoaded, selectedSquare];

  BoardState copyWith({
    BoardModel? board,
    bool? isLoaded,
    SquareModel? selectedSquare,
    PlayerTurn? playerTurn,
  }) {
    return BoardState(
      board: board ?? this.board,
      isLoaded: isLoaded ?? this.isLoaded,
      selectedSquare: selectedSquare,
      playerTurn: playerTurn ?? this.playerTurn,
    );
  }
}
