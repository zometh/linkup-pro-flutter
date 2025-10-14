import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_page.dart';
import 'package:linkup_pro/main.dart';

class AccountChoice extends StatelessWidget {
  const AccountChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.all(constraints.maxWidth * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: "account_choice_title".tr(),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                fontSize: constraints.maxWidth * 0.045,
              ),
              SizedBox(height: constraints.maxHeight * 0.035),
              AccountTypeTile(
                height: constraints.maxHeight,
                icon: Icons.person,
                title: "account_choice_individual_title".tr(),
                description: "account_choice_individual_description".tr(),
                onTap: () => _navigate(context),
              ),
              const SizedBox(height: 16),
              AccountTypeTile(
                height: constraints.maxHeight,
                icon: Icons.business,
                title: "account_choice_business_title".tr(),
                description: "account_choice_business_description".tr(),
                onTap: () => _navigate(context, isEntreprise: true) ,
              ),
            ],
          ),
        );
      },
    );
  }
  _navigate(BuildContext context,{bool isEntreprise = false}) {

    final route = MaterialPageRoute(builder: (_) {
      return RegisterPage(isEntreprise: isEntreprise);

    });
    Navigator.push(context, route);
  }
}

class AccountTypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double height;
  final VoidCallback onTap;

  const AccountTypeTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          gradient: AppGradients.primaryGradient,
        ),
        child: Row(
          children: [
            Icon(icon, size: context.isMobile ? 24 : 36, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    // fontFamily: "Poppins",
                    color: Colors.white,
                    fontSize: context.screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: height * 0.01),
                  CustomText(
                    text: description,
                    // fontFamily: "Poppins",
                    fontSize: context.screenWidth * 0.03,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
