import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

class SalmonCheckboxListTile extends HookWidget {
  const SalmonCheckboxListTile({
    required this.title,
    required this.onChanged,
    this.value = false,
    super.key,
  });

  final Widget title;
  final void Function(bool?) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: title,
      activeColor: context.cs.primary,
      checkColor: context.cs.primaryContainer,
      checkboxShape: const CircleBorder(),
      value: value,
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}
