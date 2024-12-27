import 'package:equatable/equatable.dart';

/// Enum đại diện cho loại quân cờ
enum PieceType {
  king,
  queen,
  rook,
  bishop,
  knight,
  pawn,
}

/// Enum đại diện cho màu quân cờ
enum PieceColor {
  white,
  black,
}

/// Lớp đại diện cho một quân cờ
class PieceModel extends Equatable {
  final PieceType type;
  final PieceColor color;
  final String position; // Vị trí trên bàn cờ, ví dụ: "e4"

  const PieceModel({
    required this.type,
    required this.color,
    required this.position,
  });

  /// Kiểm tra quân cờ có phải của một màu cụ thể không
  bool isOfColor(PieceColor color) {
    return this.color == color;
  }

  /// Chuyển quân cờ sang định dạng chuỗi
  @override
  String toString() {
    return '${color.name} ${type.name} at $position';
  }

  @override
  List<Object?> get props => [type, color, position];

  /// Vị trí ban đầu của các quân cờ
  static PieceModel initializePieceForRow(int column, PieceColor color) {
    switch (column) {
      case 0:
      case 7:
        return PieceModel(type: PieceType.rook, color: color, position: "");
      case 1:
      case 6:
        return PieceModel(type: PieceType.knight, color: color, position: "");
      case 2:
      case 5:
        return PieceModel(type: PieceType.bishop, color: color, position: "");
      case 3:
        return PieceModel(type: PieceType.queen, color: color, position: "");
      case 4:
        return PieceModel(type: PieceType.king, color: color, position: "");
      default:
        throw Exception('Invalid column for chess piece');
    }
  }
}
