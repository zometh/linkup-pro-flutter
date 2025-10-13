import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/services/my_logger.dart';
import 'package:linkup_pro/core/widgets/custom_popscope.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/register/widgets/custom_stepper.dart';

import '../../data/entities/sector.dart';
import '../../data/register_user/register_repository_implement.dart';

import '../../widgets/sector_card.dart';
import '../providers/stepper.dart';



class SectorGridView extends ConsumerStatefulWidget {


   const SectorGridView({super.key});

  @override
  ConsumerState<SectorGridView> createState() => _SectorGridViewState();
}

class _SectorGridViewState extends ConsumerState<SectorGridView> {
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    final registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();

    return RefreshIndicator(
      key: refreshKey,
      color: AppColors.primary,
      onRefresh: () async {
        setState(() {});
      },
      child: CustomPopscope(
          executeOnPop: () =>     ref.read(stepperProvider.notifier).previous()
        ,
        widget: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                SizedBox(height: constraints.maxHeight * 0.03,child: CustomStepper(),),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: CustomText(
                        text: "Choose your sector".tr(),
                        fontSize: constraints.maxWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Expanded(
                      child: FutureBuilder(
                          future: registerRepositoryImplements.getSectors(), builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CustomProgress();
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No data available'));
                        }
                        final response = snapshot.data!;
        
                        final sectors = response.fold(
                              (failure) => <Sector>[],
                              (data) {
        
                            final List<dynamic> sectorList = data ?? [];
                            return sectorList.map((e) => Sector.fromMap(e)).toList();
                          },
                        );
        
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // ou 3 selon la taille d’écran
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemCount: sectors.length,
                          itemBuilder: (context, index) {
                            final sector = sectors[index];
                            return SectorCard(
                              sector: sector,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Selected: ${sector.name}")),
                                );
                              },
                            ).animate().fadeIn(duration: 200.ms, delay: (index * 100).ms);
                          },
                        );
                      }),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}