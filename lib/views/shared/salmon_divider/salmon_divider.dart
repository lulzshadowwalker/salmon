import 'package:flutter/material.dart';

/// divider on the form of "----- child -----"
class SalmonDivider extends StatelessWidget {
  const SalmonDivider({
    required this.child,
    this.height = 64,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // one padding ([height]) is sufficient
        Expanded(child: Divider(height: height)),
        child,
        const Expanded(child: Divider()),
      ],
    );
  }
}
