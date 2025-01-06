class AIService {
  static AIService instance = AIService._privatedConstruct();
  AIService._privatedConstruct();

  // Lấy nước đi
  List<List<int>> getMove({required String board, required String playerTurn}) {
    return [
      [1, 0],
      [3, 0]
    ];
  }
}
