import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/board/bloc/board_bloc.dart';
import '../../features/board/views/board_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Game"),
        ),
        body: main(),
      ),
    );
  }

  Widget main() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: chessBoard(),
        ),
        controllerButtons(),
      ],
    );
  }

  Widget chessBoard() {
    return const BoardView();
  }

  Widget controllerButtons() {
    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) {
        return Row(
          children: [
            // Back button
            IconButton(
              onPressed: () =>
                  context.read<BoardBloc>().add(const MovingBackEvent()),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 8.0),
            // Forward button
            IconButton(
              onPressed: () =>
                  context.read<BoardBloc>().add(const MovingForwardEvent()),
              icon: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(width: 8.0),
            // Check status
            Text(state.checkStatus == CheckStatus.blackKingInCheck
                ? 'Black in check'
                : state.checkStatus == CheckStatus.whiteKingInCheck
                    ? 'White in check'
                    : state.checkStatus == CheckStatus.whiteInCheckMate
                        ? "White in checkmate"
                        : state.checkStatus == CheckStatus.blackInCheckMate
                            ? "Black in checkmate"
                            : ""),
          ],
        );
      },
    );
  }
}
