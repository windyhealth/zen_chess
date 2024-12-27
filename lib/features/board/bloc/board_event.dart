part of 'board_bloc.dart';

/// Sự kiện cho [BoardBloc]
abstract class BoardEvent extends Equatable {
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

/// Sự kiện để di chuyển một quân cờ từ ô này sang ô khác
class MovePieceEvent extends BoardEvent {
  final SquareModel from;
  final SquareModel to;

  const MovePieceEvent({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];

  @override
  String toString() => 'MovePieceEvent(from: $from, to: $to)';
}
