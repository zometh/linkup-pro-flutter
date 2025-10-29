import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkup_pro/core/utils/assets_path.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class RegisterHeader extends StatelessWidget {
  final double height;
  final double width;
  final bool isCompany;
  const RegisterHeader({super.key, required this.height, required this.width, this.isCompany = false});

  @override
  Widget build(BuildContext context) {
    return Center(
                                      child: Column(
                                        children: [
                                          Center(
                                  child: Hero(
                                    tag: 'app_logo',
                                    child: Image.asset(
                                      AssetsPath.logo,
                                      width: width * 0.45,
                                      height: height * 0.08,
                                    ),
                                  ),
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                  delay: 100.ms,
                                ),

                                SizedBox(height: height * 0.03),
                                          CustomText(
                                            text: (isCompany? "complete_company" : "complete_profile").tr(),
                                            fontSize:
                                                width * 0.065,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(
                                            height:
                                                height * 0.01,
                                          ),
                                          Container(
                                            width: width * 0.15,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppGradients.primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.015),
                                          CustomText(
                                            text: (isCompany? "complete_company_infos" : "complete_profile_subtitle").tr(),
                                    fontSize: width * 0.038,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey[600],
                                  
                                ).animate().fadeIn(
                                  duration: 500.ms,
                                  delay: 300.ms,
                                ),
                                          
                                        ],
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 200.ms)
                                    .slideY(begin: -0.3, end: 0);
  }
}
