part of './salmon_drawer_components.dart';

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.title,
    this.leading,
    this.isActive = false,
    this.onTap,
  });

  final Widget? leading;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isActive ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
      ),
    );
  }
}
