import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zenchess/app/routes.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: main(),
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
      ],
    );
  }
}
