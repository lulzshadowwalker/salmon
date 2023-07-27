import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.title,
    required this.header,
    required this.color,
    super.key,
  });

  final Widget title;
  final Widget header;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 24,
          end: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            header,
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: title,
            ),
          ],
        ),
      ),
    );
  }
}
