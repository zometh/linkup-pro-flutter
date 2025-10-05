import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/main.dart';

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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Center(
          child: Image.asset(
            AssetsPath.logo,
            height: context.isMobile ? 40 : 60,
          ),
        ),
      ),*/
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (_, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                    vertical: 0 /*constraints.maxHeight * 0.02*/,
                  ),
                  child: Form(
                    key: _formKey,
                    child: context.isMobile
                        ? Column(
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
                                text: "login_header",
                                fontSize: constraints.maxWidth * 0.065,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.005),
                              CustomText(
                                text: "login_subtitle",
                                fontSize: constraints.maxWidth * 0.037,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              CustomTextField(
                                maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth,
                                controller: _emailController,
                                hintText: "username_or_email".tr(),
                                validator: (v) =>
                                    FormValidator.isValidEmailOrUsername(v!),
                                //type: TextFieldType.formatted,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.001),
                              CustomTextField(
                                maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth,
                                controller: _passwordController,
                                hintText: "password_hint".tr(),
                                type: TextFieldType.password,
                                validator: (v) =>
                                    FormValidator.isValidPassword(v!),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.008),
                              CustomButton(
                                text: "login_button".tr(),
                                onPressed: () {
                                  _formKey.currentState!.validate();
                                },
                                height: constraints.maxHeight * 0.065,
                                fontSize: constraints.maxWidth * 0.05,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.005),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "login_no_account",
                                    fontSize: constraints.maxWidth * 0.04,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to sign up page
                                    },
                                    child: CustomText(
                                      text: "login_sign_up",
                                      fontSize: constraints.maxWidth * 0.04,
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
                              SizedBox(height: constraints.maxHeight * 0.02),
                              CustomText(
                                text: "login_header",
                                fontSize: constraints.maxWidth * 0.05,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.01),
                              CustomText(
                                text: "login_subtitle",
                                fontSize: constraints.maxWidth * 0.03,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              CustomTextField(
                                maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth,
                                controller: _emailController,
                                hintText: "username_or_email".tr(),
                                validator: (v) =>
                                    FormValidator.isValidEmailOrUsername(v!),
                                //type: TextFieldType.formatted,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.014),
                              CustomTextField(
                                maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth,
                                controller: _passwordController,
                                hintText: "password_hint".tr(),
                                type: TextFieldType.password,
                                validator: (v) =>
                                    FormValidator.isValidPassword(v!),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.014),
                              CustomButton(
                                borderRadius: constraints.maxHeight * 0.012,
                                text: "login_button".tr(),
                                onPressed: () {
                                  _formKey.currentState!.validate();
                                },
                                height: constraints.maxHeight * 0.047,
                                fontSize: constraints.maxWidth * 0.035,
                                width: constraints.maxWidth,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "login_no_account",
                                    fontSize: constraints.maxWidth * 0.03,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to sign up page
                                    },
                                    child: CustomText(
                                      text: "login_sign_up",
                                      fontSize: constraints.maxWidth * 0.03,
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
    );
  }
}
