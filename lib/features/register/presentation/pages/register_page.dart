import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/utils/services/assets_path.dart';
import '../../../../core/widgets/custom_text.dart';

/*class RegisterPage extends StatelessWidget {
  final bool isEntreprise;
  const RegisterPage({super.key, this.isEntreprise = false});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: LayoutBuilder(
          builder: (_, constraints){
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Center(
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsPath.logo,
                        width: constraints.maxWidth * 0.5,
                        height: context.isMobile
                            ? constraints.maxHeight * 0.1
                            : constraints.maxHeight * 0.2,
                      ),
                      CustomText(
                        text: "register_header".tr(),
                        fontSize: constraints.maxWidth * 0.065,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.005,
                      ),
                      CustomText(
                        text: "register_subtitle".tr(),
                        fontSize: constraints.maxWidth * 0.037,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}*/
class RegisterPage extends ConsumerStatefulWidget{
  final bool isEntreprise;

  const RegisterPage({super.key, this.isEntreprise = false});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}
class _RegisterPageState extends ConsumerState<RegisterPage>{
  late TextEditingController emailController;
  late  TextEditingController passwordController;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = getInstance();
    passwordController = getInstance();
    usernameController = getInstance();
    firstNameController = getInstance();
    lastNameController = getInstance();

  }
  @override
  void dispose() {
    // TODO: implement dispose
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

    return Scaffold(
      /*extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,

      ),*/
      body: SafeArea(
        child: LayoutBuilder(
            builder: (_, constraints){
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                          Center(
                            child: Image.asset(
                              AssetsPath.logo,
                              width: constraints.maxWidth * 0.5,
                              height: context.isMobile
                                  ? constraints.maxHeight * 0.1
                                  : constraints.maxHeight * 0.2,
                            ),
                          ),
                          CustomText(
                            text: "register_header".tr(),
                            fontSize: constraints.maxWidth * 0.065,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.005,
                          ),
                          CustomText(
                            text: "register_subtitle".tr(),
                            fontSize: constraints.maxWidth * 0.037,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
                          ),
        
                           widget.isEntreprise ? SizedBox.shrink() : buildIndividualInfos(constraints),
        
                          CustomTextField(controller: emailController, hintText: "email".tr(),prefixIcon: Icons.email,validator: (v) => FormValidator.isValidMail(v!),
                          type: TextFieldType.formatted,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.015,
                          ),
        
                          CustomTextField(controller: usernameController, hintText: "username".tr(),prefixIcon: Icons.person,validator: (v) => FormValidator.isValidField(input: v!, maxCar: 10, nbCar:5),
                            type: TextFieldType.formatted,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.015,
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
                          ),
                          SizedBox(height: constraints.maxHeight * 0.01,),
                          CustomText(text: "choose_country".tr()),
                          SizedBox(height: constraints.maxHeight * 0.01,),
        
                          SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: constraints.maxWidth * 0.04,
                                        vertical: constraints.maxHeight * 0.015,
                                      ),
                                    ),
                                    onPressed: chooseCountry,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: CustomText(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            text: selectedCountry.name,
                                            fontWeight: FontWeight.w500,
                                            fontSize: constraints.maxWidth * 0.04,
                                          ),
                                        ),
                                        SizedBox(width: constraints.maxWidth * 0.02),
                                        Icon(Icons.arrow_drop_down, color: Colors.white, size: constraints.maxWidth * 0.09,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.015,
                          ),
                          CustomButton(text: "next".tr(), onPressed: (){},height: constraints.maxHeight * 0.07,),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
  Widget buildIndividualInfos(BoxConstraints constraints){
    return Column(
      children: [
        CustomTextField(controller: firstNameController, hintText: "first_name".tr(),prefixIcon: Icons.person,validator: (v) => FormValidator.isValidField(input: v!, maxCar: 30, nbCar: 3),),
        SizedBox(
          height: constraints.maxHeight * 0.015,
        ),
        CustomTextField(controller: lastNameController, hintText: "last_name".tr(),prefixIcon: Icons.person,validator: (v) => FormValidator.isValidField(input: v!, maxCar: 30, nbCar: 3),),
        SizedBox(
          height: constraints.maxHeight * 0.015,
        ),

      ],
    );
  }
  void chooseCountry(){
    showCountryPicker(
      context: context,
      showPhoneCode: false, // optional. Shows phone code before the country name.
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
            borderSide: BorderSide(
              
              color: AppColors.primary,
              width: 2.0,
            ),
          ),
          labelText: 'Search country by name'.tr(),
          hintText: 'Start typing to search'.tr(),
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
  TextEditingController getInstance() => TextEditingController();
}
