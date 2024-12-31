import 'package:equatable/equatable.dart';
import 'square_model.dart';
import 'piece_model.dart';

class MoveModel extends Equatable {
  const MoveModel({
    required this.piece,
    required this.pieceColor,
    required this.from,
    required this.to,
    this.capturedPiece,
  });

  final PieceModel piece;
  final PieceColor pieceColor;
  final SquareModel from;
  final SquareModel to;
  final PieceModel? capturedPiece;

  @override
  String toString() {
    return '${piece.type} - ${pieceColor.name} - from ${from.position} to ${to.position} - capture ${capturedPiece?.type}';
  }

  @override
  List<Object?> get props => [piece, pieceColor, from, to, capturedPiece];
}
