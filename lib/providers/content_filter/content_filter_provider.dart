import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/models/agency.dart';
import 'package:salmon/providers/agencies/agencies_provider.dart';

final contentTagsProvider = Provider.family<List<Agency>, String>((ref, lang) {
  final agencies = ref.watch(agenciesProvider(lang)).value;

  return UnmodifiableListView(agencies ?? []);
});

final contentFilterProvider = ChangeNotifierProvider.autoDispose
    .family<ContentFilterNotifier, String>((ref, lang) {
  final allTags = ref.watch(contentTagsProvider(lang));
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
