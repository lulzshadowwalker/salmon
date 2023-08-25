import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SalmonOverlappingStack extends HookWidget {
  const SalmonOverlappingStack({
    required this.itemCount,
    required this.itemBuilder,
    this.offset = const Offset(4, 0),
    this.limit,
    this.overflowBuilder,
    super.key,
  });

  final int itemCount;
  final int? limit;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Offset offset;
  final Widget Function(BuildContext context, int amount)? overflowBuilder;

  @override
  Widget build(BuildContext context) {
    final l = limit == null ? itemCount : min(limit ?? 0, itemCount);

    return Stack(
      children: [
        ...List.generate(
          l != itemCount ? l % itemCount : itemCount,
          (index) => Transform.translate(
            offset: Offset(
              offset.dx * index,
              offset.dy * index,
            ),
            child: itemBuilder(context, index),
          ),
        ),
        if (l != itemCount && overflowBuilder != null)
          Transform.translate(
            offset: Offset(
              offset.dx * l,
              offset.dy * l,
            ),
            child: overflowBuilder!(
              context,
              itemCount - l,
            ),
          ),
      ],
    );
  }
}
