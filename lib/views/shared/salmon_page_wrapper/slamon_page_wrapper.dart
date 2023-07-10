import 'package:flutter/material.dart';

class SalmonPageWrapper extends StatelessWidget {
  const SalmonPageWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 10,
            blurRadius: 50,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(
        vertical: 48,
        horizontal: 24,
      ),
      child: child,
    );
  }
}
