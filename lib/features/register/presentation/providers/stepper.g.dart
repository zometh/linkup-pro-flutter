// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stepper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stepper)
const stepperProvider = StepperProvider._();

final class StepperProvider extends $NotifierProvider<Stepper, int> {
  const StepperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stepperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stepperHash();

  @$internal
  @override
  Stepper create() => Stepper();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$stepperHash() => r'61fafe13a9bd6e195dc7863b1df69fc41be4a718';

abstract class _$Stepper extends $Notifier<int> {
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
