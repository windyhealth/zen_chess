import 'package:equatable/equatable.dart';
import 'piece_model.dart';

/// Mô hình dữ liệu cho một ô vuông (square) trên bàn cờ
class SquareModel extends Equatable {
  final int row; // Hàng của ô vuông
  final int column; // Cột của ô vuông
  final String color; // Màu sắc của ô vuông (ví dụ: "white" hoặc "black")
  final PieceModel? piece; // Quân cờ hiện tại trên ô (nếu có)
  final bool isNull;

  const SquareModel({
    required this.row,
    required this.column,
    required this.color,
    this.piece,
    this.isNull = true,
  });

  @override
  List<Object?> get props => [
        row,
        column,
        color,
        piece,
        isNull,
      ];

  /// Tạo một bản sao của đối tượng với các thay đổi cụ thể
  SquareModel copyWith({
    int? row,
    int? column,
    String? color,
    PieceModel? piece,
    bool? isNull,
  }) {
    return SquareModel(
      row: row ?? this.row,
      column: column ?? this.column,
      color: color ?? this.color,
      piece: piece ?? this.piece,
      isNull: isNull ?? this.isNull,
    );
  }

  /// Kiểm tra nếu ô vuông này có chứa quân cờ
  bool get hasPiece => piece != null;

  /// Trả về tọa độ dưới dạng chuỗi "row, column"
  String get position => "$row, $column";

  @override
  String toString() {
    return 'SquareModel(row: $row, column: $column, color: $color, piece: $piece)';
  }
}
