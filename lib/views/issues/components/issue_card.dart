part of './issues_components.dart';

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.title,
    required this.child,
    required this.backgroundColor,
    this.onTap,
    // ignore: unused_element
    this.size,
  });

  static const _bounceDuration = Duration(milliseconds: 80);
  static final _borderRadius = BorderRadius.circular(10);

  final String title;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: AspectRatio(
        aspectRatio: 1,
        child: Bounceable(
          onTap: () {},
          duration: _bounceDuration,
          reverseDuration: _bounceDuration,
          child: InkWell(
            onTap: onTap,
            borderRadius: _borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.4),
                borderRadius: _borderRadius,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => ConstrainedBox(
                        constraints: constraints,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          HSLColor.fromColor(backgroundColor.withOpacity(0.75))
                              .withLightness(0.5)
                              .toColor(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
