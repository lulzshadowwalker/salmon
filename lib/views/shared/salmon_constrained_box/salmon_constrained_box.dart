import 'package:flutter/material.dart';

class SalmonConstrainedBox extends StatelessWidget {
  const SalmonConstrainedBox({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 550),
      child: child,
    );
  }
}
