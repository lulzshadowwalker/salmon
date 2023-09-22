import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import 'package:salmon/providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import 'package:salmon/views/auth/components/google_auth_button.dart';
import 'package:salmon/views/auth/components/guest_auth_button.dart';
import 'package:salmon/views/shared/image_picker_circle_avatar/image_picker_circle_avatar.dart';
import 'package:salmon/views/shared/salmon_constrained_box/salmon_constrained_box.dart';
import 'package:salmon/views/shared/salmon_email_field/salmon_email_field.dart';
import 'package:salmon/views/shared/salmon_form_field/salmon_form_field.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:salmon/views/shared/salmon_password_field/salmon_password_field.dart';
import 'package:salmon/views/shared/salmon_rich_text_button/salmon_rich_text_button.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import 'package:salmon/views/shared/salmon_unfocusable_wrapper/salmon_unfocusable_wrapper.dart';
import '../../helpers/salmon_extensions.dart';
import '../../models/enums/auth_type.dart';
import '../../router/salmon_routes.dart';
import '../shared/salmon_divider/salmon_divider.dart';

class SignUp extends StatefulHookConsumerWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final isLoading = useState(false);

    return SalmonUnfocusableWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SalmonConstrainedBox(
              child: SalmonSingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        ImagePickerCircleAvatar(
                          onSelected: (image) {
                            final cred = ref
                                .read(salmonUserCredentialsProvider)
                                .credentials;

                            ref
                                .read(salmonUserCredentialsProvider.notifier)
                                .set(
                                  cred.copyWith(
                                    pfpRaw: image,
                                  ),
                                );
                          },
                        ),
                        SalmonFormField(
                          onSaved: (name) {
                            final cred = ref
                                .read(salmonUserCredentialsProvider)
                                .credentials;

                            ref
                                .read(salmonUserCredentialsProvider.notifier)
                                .set(
                                  cred.copyWith(
                                    displayName: name!.trim(),
                                  ),
                                );
                          },
                          validator: (val) => val.isEmpty
                              ? SL.of(context).whatShouldWeCallYou
                              : null,
                          prefixIcon: const Icon(FontAwesomeIcons.solidUser),
                          hintText: SL.of(context).name,
                        ),
                        SalmonEmailField(
                          onSaved: (email) {
                            final cred = ref
                                .read(salmonUserCredentialsProvider)
                                .credentials;

                            ref
                                .read(salmonUserCredentialsProvider.notifier)
                                .set(
                                  cred.copyWith(
                                    email: email!.trim(),
                                  ),
                                );
                          },
                        ),
                        SalmonPasswordField(onSaved: (password) {
                          final cred = ref
                              .read(salmonUserCredentialsProvider)
                              .credentials;

                          ref.read(salmonUserCredentialsProvider.notifier).set(
                                cred.copyWith(
                                  password: password,
                                ),
                              );
                        }),
                        const SizedBox(height: 38),
                        isLoading.value
                            ? const SalmonLoadingIndicator()
                            : OutlinedButton(
                                onPressed: () async {
                                  if (_formKey.currentState == null ||
                                      !_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  _formKey.currentState!.save();

                                  isLoading.value = true;
                                  await ref
                                      .read(a12nProvider)
                                      .emailSignUp(context);

                                  if (isMounted()) isLoading.value = false;
                                },
                                child: Text(SL.of(context).signUp),
                              ),
                        SalmonDivider(
                          child: Text(SL.of(context).or),
                        ),
                        const GoogleAuthButton(authType: AuthType.signUp),
                        const GuestAuthButton(),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: SalmonRichTextButton(
                            text: SL.of(context).alreadyHaveAnAccount,
                            textCTA: SL.of(context).signIn,
                            onTap: () =>
                                context.replaceNamed(SalmonRoutes.signIn),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
