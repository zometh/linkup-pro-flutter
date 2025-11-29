import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_popscope.dart';

import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_company.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_profile.dart';
import 'package:linkup_pro/features/register/presentation/providers/register_provider.dart';
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
  // Hold the repository and the future so we don't trigger the network call on every build
  late final RegisterRepositoryImplement _registerRepositoryImplements;
  // We intentionally keep the Future untyped here to avoid adding extra imports; it's the result of getSectors()
  late Future _sectorsFuture;

  @override
  void initState() {
    super.initState();
    _registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();
    _sectorsFuture = _registerRepositoryImplements.getSectors();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return CustomPopscope(
      executeOnPop: () => ref.read(registerProvider.notifier).deleteUser(),
      widget: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppGradients.scaffoldGradient : null,
          ),
          child: SafeArea(
            child: RefreshIndicator(
              key: refreshKey,
              color: AppColors.primary,
              onRefresh: () async {
                setState(() {
                  _sectorsFuture = _registerRepositoryImplements.getSectors();
                });
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                      child: Column(
                        children: [
                          CustomText(
                            text: "Choose your sector".tr(),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            color: isDark
                                ? Colors.white
                                : AppColors.darkBackground,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: "splash_subtitle_1".tr(),
                            fontSize: 14,
                            textAlign: TextAlign.center,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Grid
                  FutureBuilder(
                    future: _sectorsFuture,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverFillRemaining(
                          child: CustomProgress(),
                        );
                      }
                      if (snapshot.hasError) {
                        return SliverFillRemaining(
                          child: _buildErrorState(snapshot.error.toString()),
                        );
                      }
                      if (!snapshot.hasData) {
                        return SliverFillRemaining(child: _buildEmptyState());
                      }
                      final response = snapshot.data!;

                      final sectors = response.fold((failure) => <Sector>[], (
                        data,
                      ) {
                        final List<dynamic> sectorList = data ?? [];
                        return sectorList
                            .map((e) => Sector.fromMap(e))
                            .toList();
                      });

                      if (sectors.isEmpty) {
                        return SliverFillRemaining(child: _buildEmptyState());
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.95,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final sector = sectors[index];
                            return SectorCard(
                                  sector: sector,
                                  onTap: () {
                                    final route = MaterialPageRoute(
                                      builder: (_) => widget.isEntreprise
                                          ? RegisterCompany(sector: sector)
                                          : RegisterProfile(sector: sector),
                                    );
                                    Navigator.push(context, route);
                                  },
                                )
                                .animate()
                                .fadeIn(
                                  duration: 300.ms,
                                  delay: (index * 50).ms,
                                )
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 300.ms,
                                  delay: (index * 50).ms,
                                  curve: Curves.easeOut,
                                );
                          }, childCount: sectors.length),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'error'.tr(),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: error,
              fontSize: 14,
              textAlign: TextAlign.center,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _sectorsFuture = _registerRepositoryImplements.getSectors();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text('reset'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'no_data_found'.tr(),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _sectorsFuture = _registerRepositoryImplements.getSectors();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text('reset'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
