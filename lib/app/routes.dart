import 'package:go_router/go_router.dart';
import './screens/home_screen.dart';
import './screens/game_screen.dart';

final GoRouter myRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
  ],
);
