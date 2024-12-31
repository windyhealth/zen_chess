import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenchess/features/board/bloc/board_bloc.dart';
import './routes.dart';

class ZenChessApp extends StatelessWidget {
  const ZenChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: myRouter,
    );
  }
}
