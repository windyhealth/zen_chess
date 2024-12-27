part of 'gameplay_bloc.dart';

/// Lớp cơ sở cho tất cả các sự kiện của gameplay
abstract class GameplayEvent extends Equatable {
  const GameplayEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện bắt đầu một trò chơi mới
class StartNewGameEvent extends GameplayEvent {
  final String whitePlayerName; // Tên người chơi quân trắng
  final String blackPlayerName; // Tên người chơi quân đen

  const StartNewGameEvent({
    required this.whitePlayerName,
    required this.blackPlayerName,
  });

  @override
  List<Object?> get props => [whitePlayerName, blackPlayerName];
}

/// Sự kiện tạm dừng trò chơi
class PauseGameEvent extends GameplayEvent {
  const PauseGameEvent();
}

/// Sự kiện tiếp tục trò chơi
class ResumeGameEvent extends GameplayEvent {
  const ResumeGameEvent();
}

/// Sự kiện kết thúc trò chơi
class EndGameEvent extends GameplayEvent {
  final GameplayResult result; // Kết quả của trò chơi

  const EndGameEvent({
    required this.result,
  });

  @override
  List<Object?> get props => [result];
}

/// Sự kiện cập nhật trạng thái của bàn cờ
class BoardUpdatedEvent extends GameplayEvent {
  final BoardModel updatedBoard; // Trạng thái bàn cờ mới

  const BoardUpdatedEvent(this.updatedBoard);

  @override
  List<Object?> get props => [updatedBoard];
}
