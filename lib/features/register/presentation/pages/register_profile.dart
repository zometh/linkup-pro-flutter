import 'dart:io';
import 'package:faker/faker.dart' as ffaker;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/core/utils/date_picker.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';

import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_phone_picker.dart';
import 'package:linkup_pro/core/widgets/custom_popscope.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/profile_picker.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/core/widgets/textfield_label.dart';
import 'package:linkup_pro/features/register/data/entities/profile.dart';
import 'package:linkup_pro/features/register/presentation/providers/register_profile.dart';
import 'package:linkup_pro/features/register/widgets/register_header.dart';
import 'package:linkup_pro/main.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/custom_toast.dart';
import '../../data/entities/sector.dart';

class RegisterProfile extends ConsumerStatefulWidget {
  final Sector sector;
  const RegisterProfile({super.key, required this.sector});

  @override
  ConsumerState<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends ConsumerState<RegisterProfile>{
  late TextEditingController _biographyController;
  late TextEditingController _phoneController;
  late TextEditingController _portfolioController;
  final faker = ffaker.Faker();
  File? _selectedFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime(2010);
  String _fullPhoneNumber = '';
  PhoneNumber _phoneNumber = PhoneNumber(dialCode: "+221", isoCode: "SN");

  @override
  initState() {
    super.initState();
    _biographyController = getInstance(initial: faker.lorem.sentence());
    _phoneController = getInstance();
    _portfolioController = getInstance(initial: faker.internet.httpsUrl());
  
  }

  @override
  void dispose() {
    _biographyController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = ref.watch(registerProfileProvider);
    return CustomPopscope(
      executeOnPop: () {},
      widget: Scaffold(
        appBar: null,
        body: loading
            ? const CustomProgress().animate().fadeIn(duration: 500.ms)
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
                        physics: const BouncingScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05,
                              vertical: constraints.maxHeight * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                
                                RegisterHeader(height: constraints.maxHeight, width: constraints.maxWidth, isCompany: false,),

                                SizedBox(height: constraints.maxHeight * 0.03),
                                ProfilePicker(imageFile: _selectedFile, constraints: constraints,
                                  onImageSelected: (file) {
                                    setState(() {
                                      _selectedFile = file;
                                    });
                                  },
                                  onImageRemove: () {
                                    setState(() {
                                      _selectedFile = null;
                                    });
                                  },
                                
                                ),
SizedBox(height: constraints.maxHeight * 0.03),
                                TextfieldLabel(title: "biography", icon: Icons.info_outline_rounded, constraints: constraints),

                                SizedBox(height: constraints.maxHeight * 0.015),

                                CustomTextField(
                                      controller: _biographyController,
                                      hintText: "about_me".tr(),
                                      prefixIcon: Icons.edit_note_rounded,
                                      maxLines: 4,
                                      maxLength: 200,
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 600.ms)
                                    .slideX(begin: -0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.025),
                           
                               TextfieldLabel(title: "portfolio", icon: Icons.public_rounded, constraints: constraints),

                                SizedBox(height: constraints.maxHeight * 0.015),

                                CustomTextField(
                                  type: TextFieldType.formatted,
                                      controller: _portfolioController,
                                      hintText: "https://www.example.com",
                                      validator: (value) => FormValidator.isValidWebsite(website: value!)
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 600.ms)
                                    .slideX(begin: -0.2, end: 0),
                                SizedBox(height: constraints.maxHeight * 0.025),
                            
                                TextfieldLabel(title: "phone", icon: Icons.phone_rounded, constraints: constraints),


                                SizedBox(height: constraints.maxHeight * 0.01),

                                CustomPhonePicker(
                                      textEditingController: _phoneController,
                                      initialValue: _phoneNumber,
                                      onPhoneNumberChanged:
                                          (PhoneNumber phone) {
                                            _phoneNumber = phone;
                                            _fullPhoneNumber =
                                                phone.phoneNumber ?? '';
                                          },
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 800.ms)
                                    .slideX(begin: 0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.01),
                                TextfieldLabel(title: "birth_date", icon: Icons.cake_sharp, constraints: constraints),
                             
                                SizedBox(height: constraints.maxHeight * 0.01),
                                InkWell(
                                  onTap: ( ) {
                                    pickDate(onDatePicked: (pickedDate) {
                                      setState(() {
                                        _selectedDate = pickedDate;
                                      });
                                    }, context: context,
                                    onAdjusted: (){
                                      // Affiche un SnackBar pour informer l'utilisateur
                                      showToast(description: 'selected_date_was_adjusted'.tr(),
                                          type: ToastificationType.info
                                      );

                                    }
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: constraints.maxHeight * 0.02,
                                      horizontal: constraints.maxWidth * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.isDarkMode
                                          ? Color.fromRGBO(30, 41, 59, 1).withValues(
                                              alpha: .5,
                                            ) // Gris foncé semi-transparent en mode sombre
                                          : AppColors.primary
                                                .withValues(alpha: .03)
                                                .withValues(alpha: 0.03),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          text: DateFormat.yMMMMd().format(
                                                  _selectedDate,
                                                ),
                                          fontSize: constraints.maxWidth * 0.04,
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        Icon(Icons.arrow_circle_down_rounded),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: constraints.maxHeight * 0.01),
                                SizedBox(
                                  width: double.infinity,
                                  child:
                                      CustomButton(
                                            text: "finish".tr(),
                                            onPressed: _submit,
                                            height:
                                                constraints.maxHeight * 0.065,
                                            //width: double.infinity,
                                          )
                                          .animate()
                                          .fadeIn(
                                            duration: 500.ms,
                                            delay: 900.ms,
                                          )
                                          .slideY(begin: 0.3, end: 0),
                                ),

                                SizedBox(height: constraints.maxHeight * 0.02),
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


 

  _submit() async {
    if(_fullPhoneNumber.isNotEmpty){
      if (_formKey.currentState?.validate() ?? false) {
      final bio = _biographyController.text.trim();
      final portfolio = _portfolioController.text.trim();

      final profile = Profile(
        sector: widget.sector.id,

        biography: bio.isEmpty ? null : bio,
        phone: _fullPhoneNumber,
        birthDate: _selectedDate,
        portfolio: portfolio.isEmpty ? null : portfolio,
        file: _selectedFile,
      );

      try {
        final response = await ref
            .read(registerProfileProvider.notifier)
            .createProfile(profile);

        // Si le widget a été démonté pendant l'opération async, on ne fait rien
        if (!mounted) return;

        if (response) {
          final storage = FlutterSecureStorage();
          await storage.write(key: 'isRegistrationComplete', value: 'true');

          if(mounted){
            MyNavigator(context).navigateToHomeAndClearStack();
          }
          //context.go( '/');
        } else {
          showToast(description: 'profile_creation_failed'.tr(),
              type: ToastificationType.error
          );
        }
      } catch (e) {
        showToast(description: 'error_occurred'.tr(),
            type: ToastificationType.error
        );

      }
    }
    }else{
      showToast(description: 'please_enter_a_valid_phone_number'.tr(),
          type: ToastificationType.error
      );

    }
  }
}
