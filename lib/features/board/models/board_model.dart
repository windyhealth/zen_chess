import 'package:equatable/equatable.dart';
import 'square_model.dart';
import 'piece_model.dart';

/// Mô hình dữ liệu cho bàn cờ
class BoardModel extends Equatable {
  final List<List<SquareModel>>
      squares; // Ma trận đại diện cho các ô vuông trên bàn cờ

  const BoardModel({
    required this.squares,
  });

  @override
  List<Object?> get props => [squares];

  /// Lấy ô vuông tại một vị trí cụ thể
  SquareModel? getSquare(int row, int column) {
    if (row < 0 ||
        row >= squares.length ||
        column < 0 ||
        column >= squares[row].length) {
      return null; // Vị trí không hợp lệ
    }
    return squares[row][column];
  }

  /// Cập nhật một ô vuông trong bàn cờ
  BoardModel updateSquare(SquareModel updatedSquare) {
    List<List<SquareModel>> newSquares = squares
        .map((row) => row.map((square) {
              if (square.row == updatedSquare.row &&
                  square.column == updatedSquare.column) {
                return updatedSquare;
              }
              return square;
            }).toList())
        .toList();

    return BoardModel(squares: newSquares);
  }

  /// Chuyển đổi bàn cờ sang định dạng chuỗi để hiển thị hoặc debug
  @override
  String toString() {
    return squares
        .map((row) => row.map((square) => square.toString()).join(', '))
        .join('\n');
  }

  /// Kiểm tra xem bàn cờ có chứa quân cờ của một màu cụ thể không
  bool hasPiecesOfColor(String color) {
    for (var row in squares) {
      for (var square in row) {
        if (square.piece != null && square.piece!.color.name == color) {
          return true;
        }
      }
    }
    return false;
  }

  /// Khởi tạo bàn cờ với trạng thái mặc định
  static BoardModel initializeBoard() {
    const int size = 8;
    final squares = List.generate(
      size,
      (row) => List.generate(
        size,
        (column) {
          PieceModel? piece;
          if (row == 0 || row == 7) {
            final color = row == 0 ? PieceColor.black : PieceColor.white;
            piece = PieceModel.initializePieceForRow(column, color);
          } else if (row == 1 || row == 6) {
            final color = row == 1 ? PieceColor.black : PieceColor.white;
            piece = PieceModel(
                type: PieceType.pawn, color: color, position: "$row$column");
          }
          return SquareModel(
            row: row,
            column: column,
            color: (row + column) % 2 == 0 ? 'white' : 'black',
            piece: piece,
          );
        },
      ),
    );
    return BoardModel(squares: squares);
  }
}
