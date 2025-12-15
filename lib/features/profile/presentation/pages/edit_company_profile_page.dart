import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_phone_picker.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/features/profile/presentation/providers/edit_profile_provider.dart';

class EditCompanyProfilePage extends ConsumerStatefulWidget {
  final Company company;

  const EditCompanyProfilePage({super.key, required this.company});

  @override
  ConsumerState<EditCompanyProfilePage> createState() =>
      _EditCompanyProfilePageState();
}

class _EditCompanyProfilePageState
    extends ConsumerState<EditCompanyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  File? _selectedLogo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.company.name);
    _descriptionController = TextEditingController(
      text: widget.company.description,
    );
    _websiteController = TextEditingController(text: widget.company.website);
    _phoneController = TextEditingController(text: widget.company.phone);
    _addressController = TextEditingController(
      text: widget.company.user.address,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedLogo = File(image.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(editProfileProvider.notifier)
        .updateCompanyProfile(
          companyId: widget.company.id,
          name: _nameController.text.trim().isEmpty
              ? null
              : _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          website: _websiteController.text.trim().isEmpty
              ? null
              : _websiteController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          logo: _selectedLogo,
        );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile_updated_successfully'.tr())),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('error_updating_profile'.tr())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final editState = ref.watch(editProfileProvider);

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.darkSurface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CustomText(
          text: 'edit_profile'.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
        actions: [
          if (editState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _submit,
              child: CustomText(
                text: 'save'.tr(),
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkSurface
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: _selectedLogo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedLogo!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : (widget.company.logo.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    widget.company.logo,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.business,
                                  size: 60,
                                  color: isDarkMode
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400,
                                )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Company Name
            CustomText(
              text: 'company_name'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              hintText: 'company_name'.tr(),
            ),
            const SizedBox(height: 16),

            // Description
            CustomText(
              text: 'description'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _descriptionController,
              hintText: 'company_description'.tr(),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Website
            CustomText(
              text: 'website'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _websiteController,
              hintText: 'company_website'.tr(),
            ),
            const SizedBox(height: 16),

            // Phone
            CustomText(
              text: 'phone_number'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomPhonePicker(
              textEditingController: _phoneController,
              initialValue: widget.company.phone.isNotEmpty
                  ? PhoneNumber(phoneNumber: widget.company.phone)
                  : null,
              onPhoneNumberChanged: (PhoneNumber number) {
                // Le numéro sera automatiquement mis à jour dans le controller
              },
            ),
            const SizedBox(height: 16),

            // Address
            CustomText(
              text: 'address'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _addressController,
              hintText: 'company_address'.tr(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
