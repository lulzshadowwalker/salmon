part of './event_components.dart';

class _EventData extends InheritedWidget {
  const _EventData({
    required this.data,
    required super.child,
  });

  final Event data;

  static _EventData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_EventData>();
  }

  @override
  bool updateShouldNotify(_EventData oldWidget) {
    return data != oldWidget.data;
  }
}
