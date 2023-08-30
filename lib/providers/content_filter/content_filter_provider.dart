import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/agency.dart';
import 'package:salmon/providers/agencies/agencies_provider.dart';

final contentTagsProvider = Provider<List<Agency>>((ref) {
  final agencies = ref.watch(agenciesProvider).value;

  return UnmodifiableListView(agencies ?? []);
});

final contentFilterProvider = ChangeNotifierProvider.autoDispose((ref) {
  final allTags = ref.watch(contentTagsProvider);
  return ContentFilterNotifier<Agency>(List.from(allTags));
});

class ContentFilterNotifier<T> extends ChangeNotifier {
  ContentFilterNotifier(List<T> tags)
      : _tags = List.from(tags),
        _allTags = UnmodifiableListView(tags);

  final List<T> _tags;
  final List<T> _allTags;

  List<T> get tags => UnmodifiableListView(_tags);

  bool get isActive =>
      !const DeepCollectionEquality.unordered().equals(_tags, _allTags);

  void toggleSelect(T tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
      return;
    }

    if (_tags.length <= 1) return;

    _tags.remove(tag);
    notifyListeners();
  }

  bool get areAllSelected => _tags.length == _allTags.length;
}
