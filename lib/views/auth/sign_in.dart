import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/router/salmon_routes.dart';
import 'package:salmon/views/auth/components/google_auth_button.dart';
import 'package:salmon/views/auth/components/guest_auth_button.dart';
import 'package:salmon/views/shared/salmon_email_field/salmon_email_field.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import 'package:salmon/views/shared/salmon_password_field/salmon_password_field.dart';
import 'package:salmon/views/shared/salmon_rich_text_button/salmon_rich_text_button.dart';
import 'package:salmon/views/shared/salmon_single_child_scroll_view/salmon_single_child_scroll_view.dart';
import '../../models/enums/auth_type.dart';
import '../../providers/a12n/a12n_provider.dart';
import '../../providers/salmon_user_credentials/salmon_user_credentials_provider.dart';
import '../shared/salmon_divider/salmon_divider.dart';

class SignIn extends StatefulHookConsumerWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final isLoading = useState(false);

    return Scaffold(
      body: SafeArea(
        child: SalmonSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SalmonEmailField(onSaved: (email) {
                    final cred =
                        ref.read(salmonUserCredentialsProvider).credentials;

                    ref.read(salmonUserCredentialsProvider.notifier).set(
                          cred.copyWith(
                            email: email,
                          ),
                        );
                  }),
                  SalmonPasswordField(onSaved: (password) {
                    final cred =
                        ref.read(salmonUserCredentialsProvider).credentials;

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
                          child: Text(SL.of(context).signIn),
                          onPressed: () async {
                            if (_formKey.currentState == null ||
                                !_formKey.currentState!.validate()) return;

                            _formKey.currentState!.save();

                            isLoading.value = true;
                            await ref.read(a12nProvider).emailSignIn(context);

                            if (isMounted()) isLoading.value = false;
                          },
                        ),
                  SalmonDivider(
                    child: Text(SL.of(context).or),
                  ),
                  const GoogleAuthButton(authType: AuthType.signIn),
                  const GuestAuthButton(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: SalmonRichTextButton(
                      text: SL.of(context).dontHaveAnAccount,
                      textCTA: SL.of(context).signUp,
                      onTap: () => context.replaceNamed(SalmonRoutes.signUp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
