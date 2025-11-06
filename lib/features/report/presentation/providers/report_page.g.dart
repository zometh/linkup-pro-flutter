// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReportPageProvider)
const reportPageProviderProvider = ReportPageProviderProvider._();

final class ReportPageProviderProvider
    extends $NotifierProvider<ReportPageProvider, bool> {
  const ReportPageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportPageProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportPageProviderHash();

  @$internal
  @override
  ReportPageProvider create() => ReportPageProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reportPageProviderHash() =>
    r'eb398bf82e3d345972f3fa0af8694a731bb53f44';

abstract class _$ReportPageProvider extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
