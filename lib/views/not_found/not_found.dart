import 'package:flutter/material.dart';

// TODO not-found page
class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('page not found'),
      ),
    );
  }
}
