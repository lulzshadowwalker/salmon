// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';

import '../../../providers/a12n/a12n_provider.dart';
import '../../../theme/salmon_colors.dart';
import '../../shared/salmon_email_field/salmon_email_field.dart';
import '../../shared/salmon_loading_indicator/salmon_loading_indicator.dart';

class PasswordReset extends StatefulHookConsumerWidget {
  const PasswordReset({
    super.key,
  });

  @override
  ConsumerState<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends ConsumerState<PasswordReset> {
  final _emailKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final hasValue = useState(false);
    final isMounted = useIsMounted();

    useEffect(() {
      void listener() {
        hasValue.value = controller.text.isNotEmpty;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, const []);

    final isLoading = useState(false);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FaIcon(
                  FontAwesomeIcons.solidEnvelope,
                  size: 28,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.solidCircleXmark,
                    size: 22,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              context.sl.resetPasswordHeader,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.sl.enterEmailAndWeWillSendYouPasswordResetLink,
              style: TextStyle(color: SalmonColors.muted),
            ),
            SalmonEmailField(
              fieldKey: _emailKey,
              controller: controller,
            ),
            Center(
              child: SizedBox(
                height: 92,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 550),
                  reverseDuration: const Duration(milliseconds: 650),
                  child: hasValue.value
                      ? !isLoading.value
                          ? ElevatedButton(
                              onPressed: () async {
                                if (_emailKey.currentState == null ||
                                    !_emailKey.currentState!.validate()) return;

                                _emailKey.currentState!.save();

                                isLoading.value = true;
                                await ref
                                    .read(a12nProvider)
                                    .sendPasswordResetEmail(
                                      context,
                                      controller.text.trim(),
                                    );
                                if (isMounted()) isLoading.value = false;
                                Navigator.of(context).pop();
                              },
                              child: Text(context.sl.sendPasswordResetEmail),
                            )
                          : const SalmonLoadingIndicator()
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
