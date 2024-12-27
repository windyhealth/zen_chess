import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/board_bloc.dart';
import '../models/board_model.dart';
import '../models/square_model.dart';
import '../widgets/chess_square.dart';

/// Giao diện hiển thị bàn cờ
class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BoardBloc>().add(const LoadBoardEvent());

    return BlocBuilder<BoardBloc, BoardState>(
      builder: (context, state) {
        if (state.board.squares == []) {
          return const Center(
            child: Text('Đang khởi tạo bàn cờ...'),
          );
        } else if (state.isLoaded) {
          return _buildBoard(state.board);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Xây dựng giao diện bàn cờ dựa trên mô hình dữ liệu
  Widget _buildBoard(BoardModel board) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: board.squares.length * board.squares[0].length,
          itemBuilder: (context, index) {
            final row = index ~/ 8;
            final column = index % 8;
            final square = board.squares[row][column];

            return ChessSquare(
              square: square,
              onTap: () => _onSquareTapped(context, square),
            );
          },
        ),
      ),
    );
  }

  /// Xử lý sự kiện khi một ô vuông được nhấn
  void _onSquareTapped(BuildContext context, SquareModel square) =>
      context.read<BoardBloc>().add(
            SquareTappedEvent(selectedSquare: square),
          );
}
