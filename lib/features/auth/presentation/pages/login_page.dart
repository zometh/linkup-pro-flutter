import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/formatters/fomat_text.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:linkup_pro/main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // ...existing code...

  @override
  Widget build(BuildContext context) {
    final bool loading = ref.watch(authProvider);
    return Scaffold(
      body: loading
          ? CustomProgress().animate().fadeIn(duration: 500.ms)
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: context.isDarkMode
                      ? [
                          Color(0xFF1a1a2e),
                          Color(0xFF16213e),
                        ]
                      : [
                          Colors.white,
                          AppColors.primary.withOpacity(0.05),
                        ],
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.06,
                            vertical: constraints.maxHeight * 0.02,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.08),

                                // Logo avec animation
                                Image.asset(
                                  AssetsPath.logo,
                                  width: constraints.maxWidth * 0.5,
                                  height: context.isMobile
                                      ? constraints.maxHeight * 0.15
                                      : constraints.maxHeight * 0.25,
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                ),

                                SizedBox(height: constraints.maxHeight * 0.04),

                                // Titre avec animation
                                CustomText(
                                  text: "login_header".tr(),
                                  fontSize: constraints.maxWidth * 0.075,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 200.ms)
                                  .slideY(begin: -0.3, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.015),

                                CustomText(
                                  text: "login_subtitle".tr(),
                                  fontSize: constraints.maxWidth * 0.04,
                                  textAlign: TextAlign.center,
                                  color: Colors.grey[600],
                                ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

                                SizedBox(height: constraints.maxHeight * 0.05),

                                // Email field avec animation
                                CustomTextField(
                                  controller: emailController,
                                  hintText: "email".tr(),
                                  prefixIcon: Icons.email_outlined,
                                  validator: (v) => FormValidator.isValidMail(v!.trim()),
                                  type: TextFieldType.formatted,
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 400.ms)
                                  .slideX(begin: -0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.025),

                                // Password field avec animation
                                CustomTextField(
                                  prefixIcon: Icons.lock_outline_rounded,
                                  maxHeight: constraints.maxHeight,
                                  maxWidth: constraints.maxWidth,
                                  controller: passwordController,
                                  hintText: "password_hint".tr(),
                                  type: TextFieldType.password,
                                  validator: (v) => FormValidator.isValidPassword(v!),
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 500.ms)
                                  .slideX(begin: 0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.025),

                                // Forgot password avec Card moderne
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () => context.go("/reset-password"),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomText(
                                        text: "forgot_password".tr(),
                                        fontSize: constraints.maxWidth * 0.035,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 600.ms)
                                  .slideX(begin: 0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.05),

                                // Login button avec animation
                                CustomButton(
                                  text: "login".tr(),
                                  onPressed: _submit,
                                  height: constraints.maxHeight * 0.065,
                                  width: double.infinity,
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 700.ms)
                                  .slideY(begin: 0.3, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.03),

                                // Register link avec design moderne
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: "no_account".tr(),
                                      fontSize: constraints.maxWidth * 0.038,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => context.go("/choice"),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: CustomText(
                                          text: "register".tr(),
                                          fontSize: constraints.maxWidth * 0.038,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).animate()
                                  .fadeIn(duration: 500.ms, delay: 800.ms),

                                SizedBox(height: constraints.maxHeight * 0.03),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  // ...existing code...
}

