import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/providers/a12n/a12n_provider.dart';
import '../../../helpers/salmon_anims.dart';
import '../../../l10n/l10n_imports.dart';
import '../../../models/enums/auth_type.dart';

class GoogleAuthButton extends HookConsumerWidget {
  const GoogleAuthButton({
    Key? key,
    required this.authType,
  }) : super(key: key);

  final AuthType authType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMounted = useIsMounted();
    final isLoading = useState(false);

    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      child: isLoading.value
          ? Transform.scale(
              scale: 5,
              child: Lottie.asset(
                SalmonAnims.googleLoading,
                reverse: true,
                frameRate: FrameRate.max,
                filterQuality: FilterQuality.low,
                height: 48,
              ),
            )
          : ElevatedButton.icon(
              onPressed: () async {
                isLoading.value = true;

                await ref.read(a12nProvider).googleAuth(context);

                if (isMounted()) isLoading.value = false;
              },
              icon: const FaIcon(
                FontAwesomeIcons.google,
                size: 16,
              ),
              label: Text(
                authType == AuthType.signIn
                    ? SL.of(context).signInWithGoogle
                    : SL.of(context).signUpWithGoogle,
              ),
            ),
    );
  }
}
