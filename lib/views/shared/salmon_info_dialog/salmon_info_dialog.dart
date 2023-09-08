
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

class SalmonInfoDialog extends StatelessWidget {
  const SalmonInfoDialog({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.onTap,
    this.buttonText,
  });

  final Widget child;
  final String title;
  final String? subtitle;

  final Function? onTap;

  /// defaults to "Continue"
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: 2,
          child: Container(
            color: HSLColor.fromColor(context.cs.primary)
                .withLightness(0.5)
                .toColor()
                .withOpacity(0.2),
            child: Container(),
          ),
        ),
        Dialog(
          insetPadding: const EdgeInsets.all(48),
          clipBehavior: Clip.none,
          child: AspectRatio(
            aspectRatio: 3.5 / 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: context.cs.primary,
                ),
                color: context.cs.background,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Spacer(),
                  FractionallySizedBox(
                    widthFactor: 0.55,
                    child: child,
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () async {
                      if (onTap != null) await onTap!();
                      Navigator.of(context).pop();
                    },
                    style: context.theme.outlinedButtonTheme.style?.copyWith(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (_) => context.cs.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(buttonText ?? context.sl.cont),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
