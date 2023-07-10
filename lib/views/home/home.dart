import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/views/home/components/salmon_bottom_nav_bar_item.dart';
import 'package:salmon/views/issues/issues.dart';
import 'package:salmon/views/shared/animated_menu_icon/animated_menu_icon.dart';
import '../../providers/home/home_provider.dart';
import '../chat/chat.dart';
import '../feed/feed.dart';
import 'components/animated_chat_icon.dart';
import 'components/animated_home_icon.dart';
import 'components/animated_issues_icon.dart';

class Home extends HookConsumerWidget {
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: ref.read(homeProvider.notifier).set,
            elevation: 0,
            backgroundColor: Colors.transparent,
            enableFeedback: true,
            items: [
              BottomNavigationBarItem(
                label: SL.of(context).feed,
                icon: SalmonBottomNavbarItem(
                  isActive: index == 0,
                  child: AnimatedHomeIcon(
                    isActive: index == 0,
                    scale: 1.1,
                  ),
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
                icon: SalmonBottomNavbarItem(
                  isActive: index == 2,
                  child: AnimatedChatIcon(
                    isActive: index == 2,
                    scale: 1.2,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.only(
              top: 72.0,
              start: 42,
            ),
            child: AnimatedMenuIcon(),
          ),
          Expanded(
            child: IndexedStack(
              alignment: Alignment.center,
              index: index,
              children: const [
                Feed(),
                Issues(),
                Chat(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}