import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';

import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_company.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_profile.dart';
import 'package:linkup_pro/main.dart';

import '../../data/entities/sector.dart';
import '../../data/repos/register_repository_implement.dart';

import '../../widgets/sector_card.dart';

class SectorGridView extends ConsumerStatefulWidget {
  final bool isEntreprise;

  const SectorGridView({super.key, this.isEntreprise = false});

  @override
  ConsumerState<SectorGridView> createState() => _SectorGridViewState();
}

class _SectorGridViewState extends ConsumerState<SectorGridView> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    final registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();
    Sector? selectedSector;

    return RefreshIndicator(
      key: refreshKey,
      color: AppColors.primary,
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: context.isDarkMode
                  ? AppGradients.scaffoldGradient
                  : null,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: CustomText(
                        text: "Choose your sector".tr(),
                        fontSize: constraints.maxWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        color: AppColors.primary,
                      ),
                    ),

                    Expanded(
                      child: FutureBuilder(
                        future: registerRepositoryImplements.getSectors(),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CustomProgress();
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                          final response = snapshot.data!;

                          final sectors = response.fold(
                            (failure) => <Sector>[],
                            (data) {
                              final List<dynamic> sectorList = data ?? [];
                              return sectorList
                                  .map((e) => Sector.fromMap(e))
                                  .toList();
                            },
                          );

                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // ou 3 selon la taille d’écran
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1,
                                ),
                            itemCount: sectors.length,
                            itemBuilder: (context, index) {
                              final sector = sectors[index];
                              return SectorCard(
                                selected: sector == selectedSector,
                                sector: sector,
                                onTap: () {
                                  setState(() {
                                    selectedSector = sector;
                                  });
                                  final route = MaterialPageRoute(
                                    builder: (_) => widget.isEntreprise
                                        ? RegisterCompany(sector: sector)
                                        : RegisterProfile(sector: sector),
                                  );
                                  Navigator.push(context, route);
                                },
                              ).animate().fadeIn(
                                duration: 200.ms,
                                delay: (index * 100).ms,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
