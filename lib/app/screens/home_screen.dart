import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: main(),
    );
  }

  Widget main() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextButton(
            onPressed: () => context.push('/game'),
            child: const Text(
              "Open Game",
            ),
          ),
        ],
      ),
    );
  }
}
