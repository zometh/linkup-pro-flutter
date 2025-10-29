import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker/faker.dart' as _faker;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/core/widgets/custom_toast.dart';
import 'package:linkup_pro/core/utils/date_picker.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/formatters/form_validator.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_phone_picker.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/profile_picker.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/core/widgets/textfield_label.dart';
import 'package:linkup_pro/features/register/data/entities/entreprise.dart';
import 'package:linkup_pro/features/register/data/entities/sector.dart';
import 'package:linkup_pro/features/register/presentation/providers/register_company.dart';
import 'package:linkup_pro/features/register/widgets/entreprise_size_choice.dart';
import 'package:linkup_pro/features/register/widgets/register_header.dart';
import 'package:linkup_pro/main.dart';
import 'package:toastification/toastification.dart';

class RegisterCompany extends ConsumerStatefulWidget {
  final Sector sector;

  const RegisterCompany({super.key, required this.sector});

  @override
  ConsumerState<RegisterCompany> createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends ConsumerState<RegisterCompany> {
  final faker = _faker.Faker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;
  DateTime creationDate = DateTime.now();
  String _fullPhoneNumber = '';
  PhoneNumber _phoneNumber = PhoneNumber(dialCode: "+221", isoCode: "SN");
  File? _logoFile;
  CompanySize _selectedSize = CompanySize.small;
  @override
  void initState() {
    super.initState();
    _phoneController = getInstance();
    _nameController = getInstance(initial: faker.company.name());
    _descriptionController = getInstance(initial: faker.lorem.sentence());
    _websiteController = getInstance(
      initial:
          'https://www.${faker.company.name().toLowerCase().replaceAll(' ', '')}.com',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(registerCompanyProvider);

    return Scaffold(
      body: isLoading
          ? const CustomProgress().animate().fadeIn(duration: 300.ms)
          : Container(
              height: double.infinity,
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
                            children: [
                              RegisterHeader(
                                height: constraints.maxHeight,
                                width: constraints.maxWidth,
                                isCompany: true,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              Center(
                                child: CustomText(text: "company_logo".tr()),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              ProfilePicker(
                                imageFile: _logoFile,
                                constraints: constraints,
                                onImageSelected: (file) {
                                  setState(() {
                                    _logoFile = file;
                                  });
                                },
                                onImageRemove: () {
                                  setState(() {
                                    _logoFile = null;
                                  });
                                },
                              ),
                              SizedBox(height: constraints.maxHeight * 0.03),
                              TextfieldLabel(
                                title: "name_of_your_company",
                                icon: Icons.business,
                                constraints: constraints,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              CustomTextField(
                                controller: _nameController,
                                hintText: "Ex: LinkUp Pro",
                                type: TextFieldType.formatted,
                                validator: (value) =>
                                    FormValidator.isValidField(
                                      input: value!,
                                      maxCar: 30,
                                      nbCar: 5,
                                    ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              TextfieldLabel(
                                title: "describe_your_company",
                                icon: Icons.description,
                                constraints: constraints,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              CustomTextField(
                                controller: _descriptionController,
                                hintText:
                                    "Ex: A brief description of your company",
                                type: TextFieldType.formatted,
                                maxLines: 5,
                                maxLength: 200,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              TextfieldLabel(
                                title: "company_website",
                                icon: Icons.link,
                                constraints: constraints,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              CustomTextField(
                                controller: _websiteController,
                                hintText: "Ex: https://www.linkuppro.com",
                                type: TextFieldType.formatted,
                                validator: (value) =>
                                    FormValidator.isValidWebsite(
                                      website: value!,
                                    ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              TextfieldLabel(
                                title: "phone",
                                icon: Icons.phone_rounded,
                                constraints: constraints,
                              ),

                              SizedBox(height: constraints.maxHeight * 0.01),

                              CustomPhonePicker(
                                    textEditingController: _phoneController,
                                    initialValue: _phoneNumber,
                                    onPhoneNumberChanged: (PhoneNumber phone) {
                                      _phoneNumber = phone;
                                      _fullPhoneNumber =
                                          phone.phoneNumber ?? '';
                                    },
                                  )
                                  .animate()
                                  .fadeIn(duration: 500.ms, delay: 800.ms)
                                  .slideX(begin: 0.2, end: 0),
                              SizedBox(height: constraints.maxHeight * 0.025),
                              TextfieldLabel(
                                title: "select_your_company_size",
                                icon: Icons.apartment,
                                constraints: constraints,
                              ),
                              SizedBox(height: constraints.maxHeight * 0.015),
                              SizedBox(
                                width: double.infinity,
                                child: EntrepriseSizeChoice(
                                  initialSelection: _selectedSize,
                                  onSizeSelected: (size) {
                                    setState(() {
                                      _selectedSize = size;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.02),
                              TextfieldLabel(
                                title: "creation_date",
                                icon: Icons.calendar_today_rounded,
                                constraints: constraints,
                              ),

                              SizedBox(height: constraints.maxHeight * 0.01),
                              InkWell(
                                onTap: () {
                                  pickDate(
                                    onDatePicked: (pickedDate) {
                                      setState(() {
                                        creationDate = pickedDate;
                                      });
                                    },
                                    context: context,
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
                                        ? Color(0xFF1E293B).withValues(
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
                                          creationDate,
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
                                          height: constraints.maxHeight * 0.065,
                                          //width: double.infinity,
                                        )
                                        .animate()
                                        .fadeIn(duration: 500.ms, delay: 900.ms)
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
    );
  }

  _submit() async {
    if (_logoFile != null) {
      if (_fullPhoneNumber.isNotEmpty) {
        if (_formKey.currentState!.validate()) {
          final entreprise = Entreprise(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            phone: _fullPhoneNumber,
            size: _selectedSize.toString().split('.').last.toUpperCase(),
            logo: _logoFile!.path,
            website: _websiteController.text.trim(),
            creationDate: creationDate,
            sector: widget.sector.id,
          );
          final result = await ref
              .read(registerCompanyProvider.notifier)
              .createCompany(entreprise);
          if (!mounted) return;

          if (result) {
            final storage = FlutterSecureStorage();
            await storage.write(key: 'isRegistrationComplete', value: 'true');

            MyNavigator(context).navigateToHomeAndClearStack();
            //context.go( '/');
          } else {
            // Affiche un message d'erreur si la création a échoué
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('profile_creation_failed'.tr())),
            );
          }
        }
      } else {
        showToast(
          description: "please_enter_a_valid_phone_number".tr(),
          type: ToastificationType.warning,
        );
        return;
      }
    } else {
      showToast(
        description: "please_upload_company_logo".tr(),
        type: ToastificationType.warning,
      );
      return;
    }
  }
}
