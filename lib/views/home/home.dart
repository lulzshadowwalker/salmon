import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:salmon/l10n/l10n_imports.dart';
import 'package:salmon/views/home/components/salmon_bottom_nav_bar_item.dart';
import 'package:salmon/views/salmon_drawer/components/salmon_drawer_components.dart';
import 'package:salmon/views/shared/salmon_navigator/salmon_navigator.dart';
import '../../providers/home/home_provider.dart';
import '../chat/chat.dart';
import '../feed/feed.dart';
import '../issues/components/issues_components.dart';
import 'components/animated_chat_icon.dart';
import 'components/animated_home_icon.dart';
import 'components/animated_issues_icon.dart';
import 'components/home_app_bar.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(homeProvider);

    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const Drawer(child: SalmonDrawer()),
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
      body: SalmonNavigator(
        child: LazyLoadIndexedStack(
          index: index,
          children: const [
            Feed(),
            Issues(),
            Chat(),
          ],
        ),
      ),
    );
  }
}
