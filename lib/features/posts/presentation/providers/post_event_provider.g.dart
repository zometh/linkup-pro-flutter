// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider pour notifier les événements de posts (création, suppression, mise à jour)
/// afin de synchroniser l'UI en temps réel

@ProviderFor(PostEventNotifier)
const postEventProvider = PostEventNotifierProvider._();

/// Provider pour notifier les événements de posts (création, suppression, mise à jour)
/// afin de synchroniser l'UI en temps réel
final class PostEventNotifierProvider
    extends $NotifierProvider<PostEventNotifier, PostEvent?> {
  /// Provider pour notifier les événements de posts (création, suppression, mise à jour)
  /// afin de synchroniser l'UI en temps réel
  const PostEventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postEventProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postEventNotifierHash();

  @$internal
  @override
  PostEventNotifier create() => PostEventNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostEvent? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostEvent?>(value),
    );
  }
}

String _$postEventNotifierHash() => r'c0e43d4c668af422ebd49d68e8b2c87d2cb6a9f5';

/// Provider pour notifier les événements de posts (création, suppression, mise à jour)
/// afin de synchroniser l'UI en temps réel

abstract class _$PostEventNotifier extends $Notifier<PostEvent?> {
  PostEvent? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PostEvent?, PostEvent?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostEvent?, PostEvent?>,
              PostEvent?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
