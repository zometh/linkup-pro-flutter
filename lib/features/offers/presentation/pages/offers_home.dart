import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/features/offers/presentation/pages/company_offer_page_new.dart';
import 'package:linkup_pro/features/offers/presentation/pages/member_offer_page_new.dart';

class OffersHome extends StatelessWidget {
  const OffersHome({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = GetIt.I<LocalDBService>();
    return FutureBuilder(
      future: dbService.getUserRole(),
      builder: (_, snapshosts) {
        if (snapshosts.connectionState == ConnectionState.waiting) {
          return const CustomProgress();
        }
        if (!snapshosts.hasData || snapshosts.data == null) {
          return const Center(child: Text("Error loading offers"));
        }
        final role = snapshosts.data!;
        return role == UserRole.member
            ? const MemberOfferPageNew()
            : const CompanyOfferPageNew();
      },
    );
  }
}
