import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:zenchess/features/board/bloc/board_bloc.dart';
import 'package:zenchess/features/board/models/board_model.dart';
import 'package:zenchess/features/board/models/piece_model.dart';
import 'package:zenchess/features/board/models/square_model.dart';

import '../../features/board/models/check_validator.dart';
import '../../features/board/models/move_validator.dart';

class AIService {
  static AIService instance = AIService._privatedConstruct();
  AIService._privatedConstruct();

  Interpreter? _interpreter;

  // Tải mô hình nếu chưa được tải
  Future<void> _ensureModelLoaded() async {
    _interpreter ??=
        await Interpreter.fromAsset("assets/ai_models/chess_model.tflite");
  }

  // Chuyển đổi BoardModel thành ma trận số nguyên
  List<List<List<double>>> _convertBoardToMatrix(
      BoardModel board, String playerTurn) {
    final isWhiteTurn = playerTurn == "white";

    // Chuyển đổi từng ô thành giá trị số
    List<List<double>> boardMatrix = board.squares.map((row) {
      return row.map((square) {
        if (square.piece == null) {
          return 0.0;
        }
        // Chuyển đổi quân cờ thành giá trị số dựa trên màu và loại quân
        final pieceValue = _getPieceValue(square.piece!.type).toDouble();
        return square.piece!.color == PieceColor.white
            ? -pieceValue
            : pieceValue;
      }).toList();
    }).toList();

    // Đảo ngược ma trận để khớp với input của mô hình
    boardMatrix = boardMatrix.reversed.toList();

    // Thêm lớp thông tin lượt đi
    List<List<double>> turnLayer = List.generate(
      8,
      (_) => List.generate(8, (_) => isWhiteTurn ? -1.0 : 1.0),
    );

    return List.generate(8,
        (i) => List.generate(8, (j) => [boardMatrix[i][j], turnLayer[i][j]]));
  }

  // Hàm ánh xạ PieceType sang giá trị số
  int _getPieceValue(PieceType type) {
    switch (type) {
      case PieceType.king:
        return 6;
      case PieceType.queen:
        return 5;
      case PieceType.rook:
        return 4;
      case PieceType.bishop:
        return 3;
      case PieceType.knight:
        return 2;
      case PieceType.pawn:
        return 1;
    }
  }

  // Lấy nước đi từ mô hình
  Future<List<SquareModel>> getMove({
    required BoardModel board,
    required String playerTurn,
  }) async {
    // Đảm bảo mô hình được tải
    await _ensureModelLoaded();

    // Chuyển đổi BoardModel thành ma trận số
    List<List<List<double>>> boardMatrix =
        _convertBoardToMatrix(board, playerTurn);

    // Chuyển ma trận thành danh sách bao gói để khớp với định dạng đầu vào (1, 8, 8, 2)
    List<List<List<List<double>>>> formattedInput = [boardMatrix];

    // Đầu ra của mô hình
    List<List<double>> output = List.generate(1, (_) => List.filled(4096, 0.0));

    // Chạy mô hình
    try {
      _interpreter!.run(formattedInput, output);
    } catch (e) {
      print('Error while running the model: $e');
      return [];
    }

    // Lấy danh sách xác suất từ output
    List<double> probabilities = output[0];

    // Tìm nước đi hợp lệ với xác suất cao nhất
    double maxProbability = -1;
    SquareModel? bestFrom;
    SquareModel? bestTo;

    for (int i = 0; i < 64; i++) {
      for (int j = 0; j < 64; j++) {
        int moveIndex = i * 64 + j;
        if (probabilities[moveIndex] > maxProbability) {
          SquareModel fromSquare = _getSquareFromIndex(board, i);
          SquareModel toSquare = _getSquareFromIndex(board, j);

          if (_validatingMove(
              board,
              playerTurn == "white" ? PlayerTurn.white : PlayerTurn.black,
              fromSquare,
              toSquare)) {
            maxProbability = probabilities[moveIndex];
            bestFrom = fromSquare;
            bestTo = toSquare;
          }
        }
      }
    }

    if (bestFrom == null || bestTo == null) {
      return [];
    }

    return [bestFrom, bestTo];
  }

  // Hàm lấy SquareModel từ chỉ số
  SquareModel _getSquareFromIndex(BoardModel board, int index) {
    int row = index ~/ 8;
    int column = index % 8;
    return board.squares[row][column];
  }

  // Kiểm tra nước đi có hợp lệ và thoát khỏi chiếu
  bool _validatingMove(BoardModel board, PlayerTurn playerTurn,
      SquareModel from, SquareModel to) {
    if (!MoveValidator.instance.isValidMove(from, to, playerTurn, board)) {
      return false;
    }

    // Kiểm tra nước đi có thoát khỏi check
    if (CheckValidator.instance.isKingInCheck(
        playerTurn == PlayerTurn.white ? PieceColor.white : PieceColor.black,
        board)) {
      return false;
    }

    return true;
  }

  // Đóng tài nguyên khi không còn cần thiết
  void close() {
    _interpreter?.close();
    _interpreter = null;
  }
}
