part of 'board_bloc.dart';

/// Sự kiện cho [BoardBloc]
sealed class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện để tải bàn cờ ban đầu
class LoadBoardEvent extends BoardEvent {
  const LoadBoardEvent();
}

/// Sự kiện khi người dùng ấn vào một ô vuông
class SquareTappedEvent extends BoardEvent {
  final SquareModel selectedSquare;

  const SquareTappedEvent({required this.selectedSquare});

  @override
  List<Object?> get props => [selectedSquare];
}
