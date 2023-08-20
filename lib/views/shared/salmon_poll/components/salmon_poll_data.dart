part of './salmon_poll_components.dart';

class PollData extends InheritedWidget {
  const PollData({
    super.key,
    required this.data,
    required super.child,
  });

  final Poll data;

  static PollData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PollData>();
  }

  @override
  bool updateShouldNotify(PollData oldWidget) {
    return data != oldWidget.data;
  }
}
