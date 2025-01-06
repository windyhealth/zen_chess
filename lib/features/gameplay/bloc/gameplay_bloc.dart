import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'gameplay_event.dart';
part 'gameplay_state.dart';

class GameplayBloc extends Bloc<GameplayEvent, GameplayState> {
  GameplayBloc() : super(const GameplayState()) {
    on<PrepareGameEvent>(_onPrepareGame);
    on<StartGameEvent>(_onStartGame);
    on<PlayerOneMoveEvent>(_onPlayerOneMove);
    on<PlayerTwoMoveEvent>(_onPlayerTwoMove);

    add(const PrepareGameEvent());
  }

  void _onPrepareGame(
      PrepareGameEvent event, Emitter<GameplayState> emit) async {
    await Future.delayed(const Duration(seconds: 3), () {});
    add(const StartGameEvent());
  }

  void _onStartGame(StartGameEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(
      gameStatus: GameStatus.playing,
    ));
  }

  void _onPlayerOneMove(PlayerOneMoveEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(
        playerTurn:
            state.playerTurn == Player.white ? Player.black : Player.white));
  }

  void _onPlayerTwoMove(PlayerTwoMoveEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(
        playerTurn:
            state.playerTurn == Player.white ? Player.black : Player.white));
  }
}
