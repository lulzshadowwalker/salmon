// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredContentTagsHash() =>
    r'dcc3525a8f14452bbad18defb124d146131d51ca';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef FilteredContentTagsRef = AutoDisposeProviderRef<List<Agency>>;

/// See also [filteredContentTags].
@ProviderFor(filteredContentTags)
const filteredContentTagsProvider = FilteredContentTagsFamily();

/// See also [filteredContentTags].
class FilteredContentTagsFamily extends Family<List<Agency>> {
  /// See also [filteredContentTags].
  const FilteredContentTagsFamily();

  /// See also [filteredContentTags].
  FilteredContentTagsProvider call({
    required String locale,
  }) {
    return FilteredContentTagsProvider(
      locale: locale,
    );
  }

  @override
  FilteredContentTagsProvider getProviderOverride(
    covariant FilteredContentTagsProvider provider,
  ) {
    return call(
      locale: provider.locale,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredContentTagsProvider';
}

/// See also [filteredContentTags].
class FilteredContentTagsProvider extends AutoDisposeProvider<List<Agency>> {
  /// See also [filteredContentTags].
  FilteredContentTagsProvider({
    required this.locale,
  }) : super.internal(
          (ref) => filteredContentTags(
            ref,
            locale: locale,
          ),
          from: filteredContentTagsProvider,
          name: r'filteredContentTagsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredContentTagsHash,
          dependencies: FilteredContentTagsFamily._dependencies,
          allTransitiveDependencies:
              FilteredContentTagsFamily._allTransitiveDependencies,
        );

  final String locale;

  @override
  bool operator ==(Object other) {
    return other is FilteredContentTagsProvider && other.locale == locale;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, locale.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
