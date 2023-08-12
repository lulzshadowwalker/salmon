import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/views/home/components/home_app_bar.dart';
import 'package:salmon/views/onboarding/onboarding.dart';
import 'package:salmon/views/salmon_drawer/components/salmon_drawer_components.dart';
import '../../providers/drawer/drawer_provider.dart';

class Interface extends ConsumerWidget {
  const Interface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(drawerPageProvider);
    return page;
  }
}
