import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/views/shared/salmon_form_field/salmon_form_field.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import '../../auth/components/eye_slash.dart';

class SalmonPasswordField extends HookConsumerWidget {
  const SalmonPasswordField({
    this.hintText,
    this.onSaved,
    this.validator,
    Key? key,
  }) : super(key: key);

  final String? hintText;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPassObscure = useState(true);
    bool isObscure = isPassObscure.value;

    return SalmonFormField(
      validator: validator ??
          (val) => val.length >= 8 ? null : SL.of(context).pickStrongPassword,
      onSaved: onSaved,
      prefixIcon: const Icon(FontAwesomeIcons.lock),
      hintText: hintText ?? context.sl.password,
      obscureText: isObscure,
      suffixIcon: IconButton(
        highlightColor: Colors.transparent,
        icon: EyeSlash(
          isObscure: isObscure,
        ),
        onPressed: () => isPassObscure.value = !isObscure,
      ),
    );
  }
}
