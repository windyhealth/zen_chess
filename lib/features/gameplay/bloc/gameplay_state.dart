part of 'gameplay_bloc.dart';

/// Enum đại diện cho trạng thái của ván cờ
enum GameplayStatus {
  initial, // Trạng thái ban đầu
  inProgress, // Đang chơi
  completed, // Ván đấu đã kết thúc
  paused // Ván đấu bị tạm dừng
}

/// Enum đại diện cho kết quả của ván cờ
enum GameplayResult {
  none, // Chưa có kết quả
  whiteWin, // Trắng thắng
  blackWin, // Đen thắng
  draw, // Hòa
}

/// Trạng thái của gameplay
class GameplayState extends Equatable {
  final BoardModel board; // Trạng thái của bàn cờ
  final PieceModel? selectedPiece; // Quân cờ được chọn hiện tại
  final GameplayStatus status; // Trạng thái hiện tại của gameplay
  final GameplayResult result; // Kết quả của gameplay (nếu có)
  final String currentPlayer; // Người chơi hiện tại ("white" hoặc "black")

  const GameplayState({
    required this.board,
    this.selectedPiece,
    this.status = GameplayStatus.initial,
    this.result = GameplayResult.none,
    this.currentPlayer = "white",
  });

  @override
  List<Object?> get props => [
        board,
        selectedPiece,
        status,
        result,
        currentPlayer,
      ];

  /// Tạo một bản sao của trạng thái với các giá trị được cập nhật
  GameplayState copyWith({
    BoardModel? board,
    PieceModel? selectedPiece,
    GameplayStatus? status,
    GameplayResult? result,
    String? currentPlayer,
  }) {
    return GameplayState(
      board: board ?? this.board,
      selectedPiece: selectedPiece ?? this.selectedPiece,
      status: status ?? this.status,
      result: result ?? this.result,
      currentPlayer: currentPlayer ?? this.currentPlayer,
    );
  }
}
