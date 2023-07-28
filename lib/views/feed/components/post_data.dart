import 'package:flutter/material.dart';

import '../../../models/post.dart';

class PostData extends InheritedWidget {
  const PostData({
    super.key,
    required this.data,
    required super.child,
  });

  final Post data;

  static PostData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PostData>();
  }

  @override
  bool updateShouldNotify(PostData oldWidget) {
    return data != oldWidget.data;
  }
}
