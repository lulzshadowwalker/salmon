import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/views/shared/salmon_loading_indicator/salmon_loading_indicator.dart';
import '../../../providers/a12n/a12n_provider.dart';

class GuestAuthButton extends HookConsumerWidget {
  const GuestAuthButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    return isLoading.value
        ? SalmonLoadingIndicator(
            color: SalmonColors.muted,
            size: 48,
          )
        : TextButton(
            onPressed: () async {
              isLoading.value = true;
              await ref.read(a12nProvider).guestSignIn(context);
              if (isMounted()) isLoading.value = false;
            },
            child: Text(
              SL.of(context).continueAsGuest,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SalmonColors.muted,
                  ),
            ),
          );
  }
}
