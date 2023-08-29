import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/views/shared/salmon_form_field/salmon_form_field.dart';
import 'package:validators/validators.dart';
import '../../../helpers/salmon_extensions.dart';

class SalmonEmailField extends ConsumerWidget {
  const SalmonEmailField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.fieldKey,
    this.onSaved,
    this.validator,
    Key? key,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final GlobalKey<FormFieldState>? fieldKey;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SalmonFormField(
      formFieldKey: fieldKey,
      controller: controller,
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator ??
          (val) => isEmail('$val') ? null : SL.of(context).enterValidEmail,
      prefixIcon: const Icon(FontAwesomeIcons.solidEnvelope),
      hintText: hintText.isEmpty ? 'email@example.com' : hintText,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
