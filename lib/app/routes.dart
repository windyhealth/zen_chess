import 'package:go_router/go_router.dart';
import 'screens/play_with_ai_game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/two_players_game_screen.dart';

final GoRouter myRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/two-players',
      builder: (context, state) => const TwoPlayersGameScreen(),
    ),
    GoRoute(
      path: '/play-with-ai',
      builder: (context, state) => const PlayWithAIGameScreen(),
    )
  ],
);
