import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenchess/core/services/ai_service.dart';
import 'package:zenchess/features/board/board_repository.dart';
import 'package:zenchess/features/board/models/square_model.dart';
import 'package:zenchess/features/gameplay/gameplay_repository.dart';

class PlayWithAIGameScreen extends StatelessWidget {
  const PlayWithAIGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BoardBloc(),
        ),
        BlocProvider(
          create: (_) => GameplayBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Play With AI"),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<BoardBloc, BoardState>(listener: (context, state) {
                if (state is NextPlayerTurnState &&
                    state.playerTurn.name == PlayerTurn.black.name) {
                  _aiTurn(context);
                }
              })
            ],
            child: main(context),
          ),
        );
      }),
    );
  }

  Widget main(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Board
        board(context),

        // Status
        status(),
      ],
    );
  }

  Widget board(BuildContext context) {
    return BoardView(
      outsideHandle: true,
      onSelectSquare: (square) async {
        final boardState = context.read<BoardBloc>().state;
        final gameplayState = context.read<GameplayBloc>().state;

        if (gameplayState.playerOne.name == boardState.playerTurn.name &&
            gameplayState.playerTurn == gameplayState.playerOne) {
          // Lượt người chơi
          context
              .read<BoardBloc>()
              .add(SquareTappedEvent(selectedSquare: square));
        }
      },
    );
  }

  Widget status() {
    return BlocBuilder<GameplayBloc, GameplayState>(builder: (context, state) {
      return Text(
        "${state.gameStatus.name} - ${state.playerTurn}",
      );
    });
  }

  Future<void> _aiTurn(BuildContext context) async {
    final boardState = context.read<BoardBloc>().state;
    final gameplayState = context.read<GameplayBloc>().state;

    // Lấy nước đi từ AI model
    if (boardState.playerTurn.name == gameplayState.playerTwo.name) {
      List<SquareModel> moves = await AIService.instance.getMove(
          board: boardState.board, playerTurn: gameplayState.playerTwo.name);

      if (moves.length == 2) {
        final boardBloc = BlocProvider.of<BoardBloc>(context);
        boardBloc.add(SquareTappedEvent(selectedSquare: moves[0]));
        boardBloc.add(SquareTappedEvent(selectedSquare: moves[1]));
      }
    }
  }
}
