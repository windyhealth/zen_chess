part of 'gameplay_bloc.dart';

enum Player { white, black }

enum GameStatus { preparing, playing, paused, ended }

class GameplayState extends Equatable {
  final Player playerOne;
  final Player playerTwo;
  final GameStatus gameStatus;
  final Player playerTurn;

  const GameplayState({
    this.playerOne = Player.white,
    this.playerTwo = Player.black,
    this.gameStatus = GameStatus.preparing,
    this.playerTurn = Player.white,
  });

  @override
  List<Object?> get props => [playerOne, playerTwo, gameStatus, playerTurn];

  GameplayState copyWith({
    Player? playerOne,
    Player? playerTwo,
    GameStatus? gameStatus,
    Player? playerTurn,
  }) {
    return GameplayState(
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      gameStatus: gameStatus ?? this.gameStatus,
      playerTurn: playerTurn ?? this.playerTurn,
    );
  }
}
