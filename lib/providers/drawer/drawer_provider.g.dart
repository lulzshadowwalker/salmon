// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$drawerPageHash() => r'b3334238795ae97001a88e2e2e36b5bbc12464be';

/// See also [DrawerPage].
@ProviderFor(DrawerPage)
final drawerPageProvider = NotifierProvider<DrawerPage, Widget>.internal(
  DrawerPage.new,
  name: r'drawerPageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$drawerPageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DrawerPage = Notifier<Widget>;
String _$drawerStateHash() => r'5c56737b900b930a0fe72e6731b5d4906c922b36';

/// See also [DrawerState].
@ProviderFor(DrawerState)
final drawerStateProvider =
    AutoDisposeNotifierProvider<DrawerState, DrawerStatus>.internal(
  DrawerState.new,
  name: r'drawerStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$drawerStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DrawerState = AutoDisposeNotifier<DrawerStatus>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
