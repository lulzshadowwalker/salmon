part of './salmon_poll_components.dart';

class PollVoteData extends InheritedWidget {
  const PollVoteData({
    super.key,
    required this.data,
    required super.child,
  });

  final PollVote? data;

  static PollVoteData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PollVoteData>();
  }

  @override
  bool updateShouldNotify(PollVoteData oldWidget) {
    return data != oldWidget.data;
  }
}
