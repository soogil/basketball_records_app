// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_records_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dateRecordsViewModelHash() =>
    r'61a61c5cc519f812822dd94f3fd03ac0bce4d937';

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

abstract class _$DateRecordsViewModel
    extends BuildlessAutoDisposeAsyncNotifier<DateRecords> {
  late final String playerId;

  FutureOr<DateRecords> build(
    String playerId,
  );
}

/// See also [DateRecordsViewModel].
@ProviderFor(DateRecordsViewModel)
const dateRecordsViewModelProvider = DateRecordsViewModelFamily();

/// See also [DateRecordsViewModel].
class DateRecordsViewModelFamily extends Family<AsyncValue<DateRecords>> {
  /// See also [DateRecordsViewModel].
  const DateRecordsViewModelFamily();

  /// See also [DateRecordsViewModel].
  DateRecordsViewModelProvider call(
    String playerId,
  ) {
    return DateRecordsViewModelProvider(
      playerId,
    );
  }

  @override
  DateRecordsViewModelProvider getProviderOverride(
    covariant DateRecordsViewModelProvider provider,
  ) {
    return call(
      provider.playerId,
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
  String? get name => r'dateRecordsViewModelProvider';
}

/// See also [DateRecordsViewModel].
class DateRecordsViewModelProvider extends AutoDisposeAsyncNotifierProviderImpl<
    DateRecordsViewModel, DateRecords> {
  /// See also [DateRecordsViewModel].
  DateRecordsViewModelProvider(
    String playerId,
  ) : this._internal(
          () => DateRecordsViewModel()..playerId = playerId,
          from: dateRecordsViewModelProvider,
          name: r'dateRecordsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dateRecordsViewModelHash,
          dependencies: DateRecordsViewModelFamily._dependencies,
          allTransitiveDependencies:
              DateRecordsViewModelFamily._allTransitiveDependencies,
          playerId: playerId,
        );

  DateRecordsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerId,
  }) : super.internal();

  final String playerId;

  @override
  FutureOr<DateRecords> runNotifierBuild(
    covariant DateRecordsViewModel notifier,
  ) {
    return notifier.build(
      playerId,
    );
  }

  @override
  Override overrideWith(DateRecordsViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: DateRecordsViewModelProvider._internal(
        () => create()..playerId = playerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playerId: playerId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DateRecordsViewModel, DateRecords>
      createElement() {
    return _DateRecordsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DateRecordsViewModelProvider && other.playerId == playerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DateRecordsViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<DateRecords> {
  /// The parameter `playerId` of this provider.
  String get playerId;
}

class _DateRecordsViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DateRecordsViewModel,
        DateRecords> with DateRecordsViewModelRef {
  _DateRecordsViewModelProviderElement(super.provider);

  @override
  String get playerId => (origin as DateRecordsViewModelProvider).playerId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
