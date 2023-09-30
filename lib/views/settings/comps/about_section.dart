part of './settings_comps.dart';

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: context.sl.aboutUs,
      options: [
        _SettingsOption(
          onTap: () {
            context.goNamed(SalmonRoutes.webview, extra: {
              'title': context.sl.cpf,
              'url': SalmonLocal.cpf(context.sl.localeName),
            });
          },
          title: Text(context.sl.cpf),
          trailing: Transform.flip(
            flipX: context.directionality == TextDirection.rtl,
            child: const Icon(
              FontAwesomeIcons.arrowUpRightFromSquare,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
