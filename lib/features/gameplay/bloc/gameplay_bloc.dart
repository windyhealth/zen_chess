import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../board/bloc/board_bloc.dart';
import '../../board/models/board_model.dart';
import '../../board/models/piece_model.dart';

part 'gameplay_event.dart';
part 'gameplay_state.dart';

class GameplayBloc extends Bloc<GameplayEvent, GameplayState> {
  final BoardBloc boardBloc;
  late final StreamSubscription boardSubscription;

  GameplayBloc({required this.boardBloc})
      : super(GameplayState(board: boardBloc.state.board)) {
    on<StartNewGameEvent>(_onStartNewGame);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<EndGameEvent>(_onEndGame);

    boardSubscription = boardBloc.stream.listen((boardState) {
      add(BoardUpdatedEvent(boardState.board));
    });
  }

  void _onStartNewGame(StartNewGameEvent event, Emitter<GameplayState> emit) {
    boardBloc.add(const LoadBoardEvent());
    emit(state.copyWith(
      status: GameplayStatus.inProgress,
      currentPlayer: "white",
    ));
  }

  void _onPauseGame(PauseGameEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(status: GameplayStatus.paused));
  }

  void _onResumeGame(ResumeGameEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(status: GameplayStatus.inProgress));
  }

  void _onEndGame(EndGameEvent event, Emitter<GameplayState> emit) {
    emit(state.copyWith(
      status: GameplayStatus.completed,
      result: event.result,
    ));
  }

  @override
  Future<void> close() {
    boardSubscription.cancel();
    return super.close();
  }
}
