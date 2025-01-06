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
          body: main(context),
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
      onSelectSquare: (square) {
        final boardState = context.read<BoardBloc>().state;
        final gameplayState = context.read<GameplayBloc>().state;

        if (gameplayState.playerOne.name == boardState.playerTurn.name &&
            gameplayState.playerTurn == gameplayState.playerOne) {
          // Lượt người chơi
          context
              .read<BoardBloc>()
              .add(SquareTappedEvent(selectedSquare: square));

          // Nếu người chơi hoàn thành xong thì đổi lượt ai

          // Lấy nước đi từ AI model

          List<List<int>> moves =
              AIService.instance.getMove(board: '', playerTurn: '');

          context.read<BoardBloc>().add(SquareTappedEvent(
              selectedSquare:
                  boardState.board.getSquare(moves[0][0], moves[0][1])!));

          context.read<BoardBloc>().add(SquareTappedEvent(
              selectedSquare:
                  boardState.board.getSquare(moves[1][0], moves[1][1])!));
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
}
