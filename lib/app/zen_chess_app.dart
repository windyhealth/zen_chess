import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenchess/features/board/board_repository.dart';

class ZenChessApp extends StatelessWidget {
  const ZenChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => Scaffold(
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
      ],
    );
  }

  Widget chessBoard() {
    return BlocProvider(
      create: (_) => BoardBloc(),
      child: const BoardView(),
    );
  }
}
