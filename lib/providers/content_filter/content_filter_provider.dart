import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:salmon/helpers/salmon_const.dart';
import 'package:salmon/helpers/salmon_images.dart';
import 'package:salmon/models/agency.dart';
import 'package:salmon/providers/agencies/agencies_provider.dart';

part 'content_filter_provider.g.dart';

const _allAgency = Agency(
  enName: 'all',
  arName: 'الجميع',
  logo: SalmonImages.agencyPlaceholder,
);

final contentTagsProvider = Provider.family<List<Agency>, String>((ref, lang) {
  final agencies = ref.watch(agenciesProvider(lang)).value;

  return UnmodifiableListView(
    (List.from(agencies ?? []))
      ..insert(
        0,
        _allAgency,
      ),
  );
});

final tagsQueryProvider = StateProvider.autoDispose((ref) => '');

@Riverpod(keepAlive: false)
List<Agency> filteredContentTags(
  FilteredContentTagsRef ref, {
  required String locale,
}) {
  final agencies = ref.watch(contentTagsProvider(locale));
  final query = ref.watch(tagsQueryProvider).toLowerCase();

  List<Agency> res = [];

  for (Agency a in agencies) {
    if (locale == SalmonConst.ar &&
        (a.arName ?? '').toLowerCase().contains(query)) {
      res.add(a);
    } else if ((a.enName ?? '').toLowerCase().contains(query)) {
      res.add(a);
    }
  }

  return UnmodifiableListView(res);
}

final contentFilterProvider = ChangeNotifierProvider.autoDispose
    .family<ContentFilterNotifier, String>((ref, lang) {
  final allTags = ref.watch(contentTagsProvider(lang));
  return ContentFilterNotifier(List.from(allTags));
});

class ContentFilterNotifier extends ChangeNotifier {
  ContentFilterNotifier(List<Agency> tags)
      : _tags = List.from(tags),
        _allTags = UnmodifiableListView(tags);

  List<Agency> _tags;
  final List<Agency> _allTags;

  List<Agency> get tags => UnmodifiableListView(_tags);

  bool get isActive =>
      !const DeepCollectionEquality.unordered().equals(_tags, _allTags);

  void toggleSelect(Agency tag) {
    if (!_tags.contains(tag)) {
      tag != _allAgency ? _tags.add(tag) : _tags = List.from(_allTags);
      notifyListeners();
      return;
    }

    if (_tags.length <= 1) return;

    if ((tag).enName != 'all') {
      _tags
        ..remove(tag)
        ..remove(_allAgency);
    } else {
      _tags.removeRange(0, _tags.length - 1);
    }

    notifyListeners();
  }

  bool get areAllSelected => _tags.length == _allTags.length;
}
