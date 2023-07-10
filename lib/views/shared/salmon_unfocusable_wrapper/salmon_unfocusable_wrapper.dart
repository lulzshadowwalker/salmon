import 'package:flutter/material.dart';

class SalmonUnfocusableWrapper extends StatelessWidget {
  const SalmonUnfocusableWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
