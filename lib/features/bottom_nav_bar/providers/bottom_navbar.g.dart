// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_navbar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BottomNavbar)
const bottomNavbarProvider = BottomNavbarProvider._();

final class BottomNavbarProvider extends $NotifierProvider<BottomNavbar, int> {
  const BottomNavbarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bottomNavbarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bottomNavbarHash();

  @$internal
  @override
  BottomNavbar create() => BottomNavbar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$bottomNavbarHash() => r'e04103f8c939eb512631518a36f48a215a911d87';

abstract class _$BottomNavbar extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
