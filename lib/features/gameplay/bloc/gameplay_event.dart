part of 'gameplay_bloc.dart';

sealed class GameplayEvent extends Equatable {
  const GameplayEvent();

  @override
  List<Object?> get props => [];
}

class PrepareGameEvent extends GameplayEvent {
  const PrepareGameEvent();
}

class StartGameEvent extends GameplayEvent {
  const StartGameEvent();
}

class PlayerOneMoveEvent extends GameplayEvent {
  const PlayerOneMoveEvent();
}

class PlayerTwoMoveEvent extends GameplayEvent {
  const PlayerTwoMoveEvent();
}
