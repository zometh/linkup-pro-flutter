import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/faker.dart' as faker_;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/formatters/fomat_text.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_popscope.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/core/entities/user.dart';
import 'package:linkup_pro/features/register/presentation/pages/sector_choice.dart';
import 'package:linkup_pro/features/register/presentation/providers/register_provider.dart';

import 'package:linkup_pro/main.dart';

import '../../../../core/utils/assets_path.dart';
import '../../../../core/widgets/custom_text.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final bool isEntreprise;

  const RegisterPage({super.key, this.isEntreprise = false});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  Country selectedCountry = Country(
    phoneCode: '1',
    countryCode: 'SN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Senegal',
    example: '+221 33 123 45 67',
    displayName: 'Senegal (SN) +221',
    displayNameNoCountryCode: 'Senegal (SN)',
    e164Key: '',
  );
  var faker = faker_.Faker();
  @override
  void initState() {
    super.initState();
    emailController = getInstance(initial: faker.internet.email());
    passwordController = getInstance(initial: "passer");
    usernameController = getInstance(initial: faker.internet.userName());
    firstNameController = getInstance(initial: faker.person.firstName());
    lastNameController = getInstance(initial: faker.person.lastName());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool loading = ref.watch(registerProvider);
    return CustomPopscope(
      executeOnPop: () => ref.read(registerProvider.notifier).deleteUser(),
      widget: Scaffold(
        body: loading
            ? CustomProgress().animate().fadeIn(duration: 500.ms)
            : Container(
                decoration: BoxDecoration(
                  gradient: context.isDarkMode
                      ? AppGradients.scaffoldGradient
                      : null,
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
                              horizontal: constraints.maxWidth * 0.04,
                              vertical: constraints.maxHeight * 0.02,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  // Logo avec animation
                                  Center(
                                    child: Image.asset(
                                      AssetsPath.logo,
                                      width: constraints.maxWidth * 0.5,
                                      height: context.isMobile
                                          ? constraints.maxHeight * 0.1
                                          : constraints.maxHeight * 0.2,
                                    ),
                                  ).animate().scale(
                                    duration: 600.ms,
                                    curve: Curves.elasticOut,
                                  ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),

                                  // Titre avec animation
                                  CustomText(
                                        text: "register_header".tr(),
                                        fontSize: constraints.maxWidth * 0.07,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                      )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 200.ms)
                                      .slideY(begin: -0.3, end: 0),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.01,
                                  ),

                                  CustomText(
                                    text: "register_subtitle".tr(),
                                    fontSize: constraints.maxWidth * 0.038,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey[600],
                                  ).animate().fadeIn(
                                    duration: 500.ms,
                                    delay: 300.ms,
                                  ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.04,
                                  ),

                                  // Informations individuelles
                                  widget.isEntreprise
                                      ? SizedBox.shrink()
                                      : buildIndividualInfos(constraints)
                                            .animate()
                                            .fadeIn(
                                              duration: 500.ms,
                                              delay: 400.ms,
                                            )
                                            .slideX(begin: -0.2, end: 0),

                                  // Champs de formulaire avec animations
                                  CustomTextField(
                                        controller: emailController,
                                        hintText: "email".tr(),
                                        prefixIcon: Icons.email_outlined,
                                        validator: (v) =>
                                            FormValidator.isValidMail(
                                              v!.trim(),
                                            ),
                                        type: TextFieldType.formatted,
                                      )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 500.ms)
                                      .slideX(begin: 0.2, end: 0),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  CustomTextField(
                                        controller: usernameController,
                                        hintText: "username".tr(),
                                        prefixIcon: Icons.person_outline,
                                        validator: (v) =>
                                            FormValidator.isValidUsername(
                                              max: 20,
                                              username: v!.trim(),
                                            ),
                                        type: TextFieldType.formatted,
                                      )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 600.ms)
                                      .slideX(begin: -0.2, end: 0),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),

                                  CustomTextField(
                                        prefixIcon: Icons.lock_outline_rounded,
                                        maxHeight: constraints.maxHeight,
                                        maxWidth: constraints.maxWidth,
                                        controller: passwordController,
                                        hintText: "password_hint".tr(),
                                        type: TextFieldType.password,
                                        validator: (v) =>
                                            FormValidator.isValidPassword(v!),
                                      )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 700.ms)
                                      .slideX(begin: 0.2, end: 0),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),

                                  // Section choix du pays améliorée
                                  CustomText(
                                    text: "choose_country".tr(),
                                    fontSize: constraints.maxWidth * 0.042,
                                    fontWeight: FontWeight.w600,
                                  ).animate().fadeIn(
                                    duration: 500.ms,
                                    delay: 800.ms,
                                  ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.015,
                                  ),

                                  Card(
                                        elevation: 2,
                                        shadowColor: AppColors.primary.withAlpha((0.2 * 255).round()),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: chooseCountry,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  constraints.maxWidth * 0.04,
                                              vertical:
                                                  constraints.maxHeight * 0.018,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.primary,
                                                  AppColors.primary.withAlpha((0.8 * 255).round()),
                                                ],
                                              ),
                                               borderRadius:
                                                   BorderRadius.circular(12),
                                             ),
                                             child: Row(
                                               children: [
                                                 Container(
                                                   padding: EdgeInsets.all(8),
                                                   /*decoration: BoxDecoration(
-
+                                                    color: Colors.white.withAlpha((0.2 * 255).round()),
                                                     borderRadius:
                                                         BorderRadius.circular(
                                                           8,
                                                         ),
                                                   )*/
                                                   child: Icon(
                                                     Icons.public,
                                                     color: Colors.white,
                                                     size:
                                                         constraints.maxWidth *
                                                         0.06,
                                                   ),
                                                 ),
                                                 SizedBox(
                                                   width:
                                                       constraints.maxWidth *
                                                       0.03,
                                                 ),
                                                 Expanded(
                                                   child: CustomText(
                                                     color: Colors.white,
                                                     overflow:
                                                         TextOverflow.ellipsis,
                                                     text: selectedCountry.name,
                                                     fontWeight: FontWeight.w600,
                                                     fontSize:
                                                         constraints.maxWidth *
                                                         0.042,
                                                   ),
                                                 ),
                                                 Icon(
                                                   Icons
                                                       .arrow_drop_down_circle_outlined,
                                                   color: Colors.white,
                                                   size:
                                                       constraints.maxWidth *
                                                       0.06,
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 900.ms)
                                      .scale(
                                        begin: Offset(0.9, 0.9),
                                        end: Offset(1, 1),
                                      ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.01,
                                  ),

                                  CustomButton(
                                        text: "next".tr(),
                                        onPressed: _submit,
                                        height: constraints.maxHeight * 0.065,
                                        width: double.infinity,
                                      )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 1000.ms)
                                      .slideY(begin: 0.3, end: 0),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
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
      ),
    );
  }

  _submit() async {
    if (formKey.currentState!.validate()) {
      final user = User(
        role: widget.isEntreprise
            ? userRoleFromString("ENTREPRISE")
            : userRoleFromString("MEMBER"),
        firstName: firstNameController.text.isEmpty
            ? null
            : FormatText.formatFormFiel(firstNameController),
        lastName: lastNameController.text.isEmpty
            ? null
            : FormatText.formatFormFiel(lastNameController),
        email: FormatText.formatFormFiel(emailController),
        address: selectedCountry.countryCode,

        password: FormatText.formatFormFiel(passwordController),
        username: FormatText.formatFormFiel(usernameController),
      );
      final response = await ref
          .read(registerProvider.notifier)
          .registerUser(user);
      if (response) {
        final route = MaterialPageRoute(
          builder: (_) => SectorGridView(isEntreprise: widget.isEntreprise),
        );
        if(mounted){
          Navigator.push(context, route);
        }
        //showToast(description: "success_register".tr(),);
      } else {} /*else{
        showToast(description: "error_register".tr(),
        type: ToastificationType.error
        );*/
    }
  }

  Widget buildIndividualInfos(BoxConstraints constraints) {
    return Column(
      children: [
        CustomTextField(
          controller: firstNameController,
          hintText: "first_name".tr(),
          prefixIcon: Icons.person_outline,
          validator: (v) => FormValidator.isValidName(
            name: v!.trim(),
            max: 30,
            min: 3,
            field: "first_name",
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.02),

        CustomTextField(
          controller: lastNameController,
          hintText: "last_name".tr(),
          prefixIcon: Icons.person_outline,
          validator: (v) => FormValidator.isValidName(
            name: v!.trim(),
            max: 30,
            min: 2,
            field: "last_name",
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.02),
      ],
    );
  }

  void chooseCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          false, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelStyle: GoogleFonts.poppins(
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          focusColor: AppColors.primary,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
          ),
          labelText: 'Search country by name'.tr(),
          hintText: 'Start typing to search'.tr(),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withAlpha(20),
            ),
          ),
        ),
      ),
    );
  }
}
