// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for managing follow state for a specific user

@ProviderFor(FollowNotifier)
const followProvider = FollowNotifierFamily._();

/// Provider for managing follow state for a specific user
final class FollowNotifierProvider
    extends $NotifierProvider<FollowNotifier, FollowState> {
  /// Provider for managing follow state for a specific user
  const FollowNotifierProvider._({
    required FollowNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'followProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$followNotifierHash();

  @override
  String toString() {
    return r'followProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FollowNotifier create() => FollowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FollowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FollowState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FollowNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followNotifierHash() => r'c6fd3ded8f4ae38377c539dae01aed01573f9e0b';

/// Provider for managing follow state for a specific user

final class FollowNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          FollowNotifier,
          FollowState,
          FollowState,
          FollowState,
          String
        > {
  const FollowNotifierFamily._()
    : super(
        retry: null,
        name: r'followProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for managing follow state for a specific user

  FollowNotifierProvider call(String userId) =>
      FollowNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'followProvider';
}

/// Provider for managing follow state for a specific user

abstract class _$FollowNotifier extends $Notifier<FollowState> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FollowState build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<FollowState, FollowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FollowState, FollowState>,
              FollowState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
