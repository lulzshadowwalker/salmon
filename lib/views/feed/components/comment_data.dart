import 'package:flutter/material.dart';

import '../../../models/comment.dart';

class CommentData extends InheritedWidget {
  const CommentData({
    super.key,
    required this.data,
    required super.child,
  });

  final Comment data;

  static CommentData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CommentData>();
  }

  @override
  bool updateShouldNotify(CommentData oldWidget) {
    return data != oldWidget.data;
  }
}
