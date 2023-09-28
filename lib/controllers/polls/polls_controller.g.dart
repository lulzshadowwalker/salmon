// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polls_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pollOptVoteCountHash() => r'4ed7d092efb7717ded9f652232e753e0199efe7c';

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

typedef PollOptVoteCountRef = ProviderRef<int>;

/// See also [pollOptVoteCount].
@ProviderFor(pollOptVoteCount)
const pollOptVoteCountProvider = PollOptVoteCountFamily();

/// See also [pollOptVoteCount].
class PollOptVoteCountFamily extends Family<int> {
  /// See also [pollOptVoteCount].
  const PollOptVoteCountFamily();

  /// See also [pollOptVoteCount].
  PollOptVoteCountProvider call(
    String pollId,
    String optId,
  ) {
    return PollOptVoteCountProvider(
      pollId,
      optId,
    );
  }

  @override
  PollOptVoteCountProvider getProviderOverride(
    covariant PollOptVoteCountProvider provider,
  ) {
    return call(
      provider.pollId,
      provider.optId,
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
  String? get name => r'pollOptVoteCountProvider';
}

/// See also [pollOptVoteCount].
class PollOptVoteCountProvider extends Provider<int> {
  /// See also [pollOptVoteCount].
  PollOptVoteCountProvider(
    this.pollId,
    this.optId,
  ) : super.internal(
          (ref) => pollOptVoteCount(
            ref,
            pollId,
            optId,
          ),
          from: pollOptVoteCountProvider,
          name: r'pollOptVoteCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pollOptVoteCountHash,
          dependencies: PollOptVoteCountFamily._dependencies,
          allTransitiveDependencies:
              PollOptVoteCountFamily._allTransitiveDependencies,
        );

  final String pollId;
  final String optId;

  @override
  bool operator ==(Object other) {
    return other is PollOptVoteCountProvider &&
        other.pollId == pollId &&
        other.optId == optId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pollId.hashCode);
    hash = _SystemHash.combine(hash, optId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$pollOptVotePercentageHash() =>
    r'ce943328cbe9510a3424d894ce30f031d638ad75';
typedef PollOptVotePercentageRef = ProviderRef<double>;

/// See also [pollOptVotePercentage].
@ProviderFor(pollOptVotePercentage)
const pollOptVotePercentageProvider = PollOptVotePercentageFamily();

/// See also [pollOptVotePercentage].
class PollOptVotePercentageFamily extends Family<double> {
  /// See also [pollOptVotePercentage].
  const PollOptVotePercentageFamily();

  /// See also [pollOptVotePercentage].
  PollOptVotePercentageProvider call(
    String pollId,
    String optId,
  ) {
    return PollOptVotePercentageProvider(
      pollId,
      optId,
    );
  }

  @override
  PollOptVotePercentageProvider getProviderOverride(
    covariant PollOptVotePercentageProvider provider,
  ) {
    return call(
      provider.pollId,
      provider.optId,
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
  String? get name => r'pollOptVotePercentageProvider';
}

/// See also [pollOptVotePercentage].
class PollOptVotePercentageProvider extends Provider<double> {
  /// See also [pollOptVotePercentage].
  PollOptVotePercentageProvider(
    this.pollId,
    this.optId,
  ) : super.internal(
          (ref) => pollOptVotePercentage(
            ref,
            pollId,
            optId,
          ),
          from: pollOptVotePercentageProvider,
          name: r'pollOptVotePercentageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pollOptVotePercentageHash,
          dependencies: PollOptVotePercentageFamily._dependencies,
          allTransitiveDependencies:
              PollOptVotePercentageFamily._allTransitiveDependencies,
        );

  final String pollId;
  final String optId;

  @override
  bool operator ==(Object other) {
    return other is PollOptVotePercentageProvider &&
        other.pollId == pollId &&
        other.optId == optId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pollId.hashCode);
    hash = _SystemHash.combine(hash, optId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
