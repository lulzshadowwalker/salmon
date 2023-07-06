import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/theme/salmon_colors.dart';
import 'package:salmon/views/issues/issues.dart';
import '../../helpers/salmon_anims.dart';
import '../../providers/home/home_provider.dart';
import '../chat/chat.dart';
import '../feed/feed.dart';
import 'components/animated_chat_icon.dart';
import 'components/animated_home_icon.dart';
import 'components/animated_issues_icon.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(homeProvider);

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: ref.read(homeProvider.notifier).set,
          elevation: 0,
          backgroundColor: Colors.transparent,
          enableFeedback: true,
          items: [
            BottomNavigationBarItem(
              label: SL.of(context).feed,
              icon: AnimatedHomeIcon(
                isActive: index == 0,
                scale: 1.1,
              ),
            ),
            BottomNavigationBarItem(
              label: SL.of(context).issues,
              icon: AnimatedIssuesIcon(
                isActive: index == 1,
              ),
            ),
            BottomNavigationBarItem(
              label: SL.of(context).chat,
              icon: AnimatedChatIcon(
                isActive: index == 2,
                scale: 1.2,
              ),
            )
          ],
        ),
      ),
      body: IndexedStack(
        alignment: Alignment.center,
        index: index,
        children: const [
          Feed(),
          Issues(),
          Chat(),
        ],
      ),
    );
  }
}
