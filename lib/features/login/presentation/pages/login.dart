import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/core/utils/services/custom_toast.dart';
import 'package:linkup_pro/core/widgets/account_choice.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/features/login/presentation/providers/auth_provider.dart';
import 'package:linkup_pro/main.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: isLoading
            ? CustomProgress().animate().fadeIn(duration: 500.ms)
            : SafeArea(
                child: Center(
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.04,
                            vertical: 0 /*constraints.maxHeight * 0.02*/,
                          ),
                          child: Form(
                            key: _formKey,
                            child: context.isMobile
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    spacing: context.isMobile
                                        ? constraints.maxHeight * 0.008
                                        : constraints.maxHeight * 0.05,
                                    children: [
                                      // SizedBox(height: constraints.maxHeight * 0.01),
                                      Image.asset(
                                        AssetsPath.logo,
                                        height: context.isMobile
                                            ? constraints.maxHeight * 0.1
                                            : constraints.maxHeight * 0.2,
                                      ),
                                      CustomText(
                                        text: "login_header".tr(),
                                        fontSize: constraints.maxWidth * 0.065,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.005,
                                      ),
                                      CustomText(
                                        text: "login_subtitle".tr(),
                                        fontSize: constraints.maxWidth * 0.037,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.015,
                                      ),
                                      CustomTextField(
                                        prefixIcon: Icons.email_outlined,
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth,
                                        controller: _emailController,
                                        hintText: "username_or_email".tr(),
                                        validator: (v) =>
                                            FormValidator.isValidEmailOrUsername(
                                              v!,
                                            ),
                                        //type: TextFieldType.formatted,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.001,
                                      ),
                                      CustomTextField(
                                        prefixIcon: Icons.lock_outline_rounded,
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth,
                                        controller: _passwordController,
                                        hintText: "password_hint".tr(),
                                        type: TextFieldType.password,
                                        validator: (v) =>
                                            FormValidator.isValidPassword(v!),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.008,
                                      ),
                                      CustomButton(
                                        text: "login_button".tr(),
                                        onPressed: _submit,
                                        height: constraints.maxHeight * 0.065,
                                        fontSize: constraints.maxWidth * 0.05,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.005,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: "login_no_account".tr(),
                                            fontSize:
                                                constraints.maxWidth * 0.035,
                                          ),
                                          GestureDetector(
                                            onTap: _register,
                                            child: CustomText(
                                              text: "login_sign_up".tr(),
                                              fontSize:
                                                  constraints.maxWidth * 0.035,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AssetsPath.logo,
                                        height: constraints.maxHeight * 0.12,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.02,
                                      ),
                                      CustomText(
                                        text: "login_header".tr(),
                                        fontSize: constraints.maxWidth * 0.05,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.01,
                                      ),
                                      CustomText(
                                        text: "login_subtitle".tr(),
                                        fontSize: constraints.maxWidth * 0.03,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.03,
                                      ),
                                      CustomTextField(
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth,
                                        controller: _emailController,
                                        hintText: "username_or_email".tr(),
                                        prefixIcon: Icons.email_outlined,
                                        validator: (v) =>
                                            FormValidator.isValidEmailOrUsername(
                                              v!,
                                            ),
                                        //type: TextFieldType.formatted,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.014,
                                      ),
                                      CustomTextField(
                                        prefixIcon: Icons.lock_outline,
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth,
                                        controller: _passwordController,
                                        hintText: "password_hint".tr(),
                                        type: TextFieldType.password,

                                        validator: (v) =>
                                            FormValidator.isValidPassword(v!),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.014,
                                      ),
                                      CustomButton(
                                        borderRadius:
                                            constraints.maxHeight * 0.012,
                                        text: "login_button".tr(),
                                        onPressed: _submit,
                                        height: constraints.maxHeight * 0.047,
                                        fontSize: constraints.maxWidth * 0.035,
                                        width: constraints.maxWidth,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: "login_no_account".tr(),
                                            fontSize:
                                                constraints.maxWidth * 0.03,
                                          ),
                                          GestureDetector(
                                            onTap: _register,
                                            child: CustomText(
                                              text: "login_sign_up".tr(),
                                              fontSize:
                                                  constraints.maxWidth * 0.03,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  _register() async {
    await showModalBottomSheet(
      elevation: 10,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
        duration: 300.ms,
        curve: Curves.easeInOut,
        reverseDuration: 300.ms,
        reverseCurve: Curves.easeInOut,
      ),
      
      context: context,
      builder: (_) => const AccountChoice(),
    );
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      bool result = await ref
          .read(authProvider.notifier)
          .signIn(
            _emailController.text.trim().toLowerCase(),
            _passwordController.text.trim().toLowerCase(),
          );
      if (result) {
        context.go("/home");
      }
    } else {
      showToast(
        applyBlurEffect: true,
        description: "Veuillez remplir tous les champs correctement",
        type: ToastificationType.error,
      );
    }
  }
}
