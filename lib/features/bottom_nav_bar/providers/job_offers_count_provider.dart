import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/offers/presentation/providers/job_offer_provider.dart';


final jobOffersCountProvider = Provider<int>((ref) {
  final targetedOffersState = ref.watch(targetedJobOffersProvider);


  return targetedOffersState.offers.length;
});


final recommendedJobOffersCountProvider = Provider<int>((ref) {
  final targetedOffersState = ref.watch(targetedJobOffersProvider);

  return targetedOffersState.recommendedOffers.length;
});

