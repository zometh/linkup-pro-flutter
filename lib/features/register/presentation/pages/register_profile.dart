import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/enums/textfield_type.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/register/data/entities/sector.dart';
import 'package:image_picker/image_picker.dart';
class RegisterProfile extends ConsumerStatefulWidget {
  final Sector sector;
  const RegisterProfile({super.key, required this.sector});

  @override
  ConsumerState<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends ConsumerState<RegisterProfile> {
  XFile? _selectedImage;
  late TextEditingController _biographyController;
  late TextEditingController _phoneController;
  late TextEditingController _portfolioController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  @override
  initState() {
    super.initState();
    _biographyController = getInstance();
    _phoneController = getInstance();
    _portfolioController = getInstance();
  }
  @override
  void dispose() {
    _biographyController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context,) {
    
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        body:  SafeArea(
          child: LayoutBuilder(builder:   (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: constraints.maxWidth * 0.05,/* vertical: constraints.maxHeight * 0.02*/),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: constraints.maxHeight * 0.03,
                      children: [
                        CustomText(text: "complete_profile".tr(), fontSize: constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                            color: AppColors.primary,),
                        InkWell(
                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                          onTap: _pcikerImage,
                          child: CircleAvatar(
                            radius: constraints.maxWidth * 0.18,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _selectedImage != null ? FileImage(
                              File(_selectedImage!.path),
                            ) : null,
                            child: _selectedImage == null ? Icon(Icons.camera_alt, size: constraints.maxWidth * 0.1, color: Colors.white,) : null,
                          ),
                        ),
                        CustomTextField(
                          maxLength: 150,
                          controller: _biographyController,
                          hintText: 'about_me'.tr(),
                          maxLines: 5,
                        ),
                        InternationalPhoneNumberInput(
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DROPDOWN,
                          ),
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onInputChanged: (PhoneNumber number) {
                            _phoneController.text = number.phoneNumber!;
                          },
                        ),
                        CustomTextField(
                          controller: _portfolioController,
                          hintText: 'portfolio'.tr(),
                          type: TextFieldType.normal,
                        ),
                        
              
                      ],
                    ),
                  ),
                )
              ),
            );
          }),
        ),
      );
  }
  Future<void> _pcikerImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final int bytes = await image.length();
    const int maxBytes = 3 * 1024 * 1024; // 3 Mo

    if (bytes <= maxBytes) {
      setState(() {
        _selectedImage = image;
      });
    } else {
      final double sizeMb = bytes / (1024 * 1024);
      ScaffoldMessenger.of(context).showSnackBar(
        
        SnackBar(
          backgroundColor: Colors.red,
          content: CustomText(
            color: Colors.white,
            text:'max_file_size'.tr(namedArgs: {'max': '3'}),
          ),
        ),
      );
    }
  }
}
