import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_phone_picker.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/features/profile/presentation/providers/edit_profile_provider.dart';

class EditMemberProfilePage extends ConsumerStatefulWidget {
  final Member member;

  const EditMemberProfilePage({super.key, required this.member});

  @override
  ConsumerState<EditMemberProfilePage> createState() =>
      _EditMemberProfilePageState();
}

class _EditMemberProfilePageState extends ConsumerState<EditMemberProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _biographyController;
  late TextEditingController _phoneController;
  late TextEditingController _portfolioController;
  late TextEditingController _addressController;
  DateTime? _birthDate;
  File? _selectedPhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.member.user.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.member.user.lastName,
    );
    _biographyController = TextEditingController(text: widget.member.biography);
    _phoneController = TextEditingController(text: widget.member.phone);
    _portfolioController = TextEditingController(text: widget.member.portfolio);
    _addressController = TextEditingController(
      text: widget.member.user.address,
    );
    _birthDate = widget.member.birthDate;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _biographyController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
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
        _selectedPhoto = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(editProfileProvider.notifier)
        .updateMemberProfile(
          profileId: widget.member.id,
          firstName: _firstNameController.text.trim().isEmpty
              ? null
              : _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim().isEmpty
              ? null
              : _lastNameController.text.trim(),
          biography: _biographyController.text.trim().isEmpty
              ? null
              : _biographyController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          birthDate: _birthDate,
          portfolio: _portfolioController.text.trim().isEmpty
              ? null
              : _portfolioController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          photo: _selectedPhoto,
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
            // Photo section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedPhoto != null
                        ? FileImage(_selectedPhoto!)
                        : (widget.member.photoUrl != null
                                  ? NetworkImage(widget.member.photoUrl!)
                                  : null)
                              as ImageProvider?,
                    child:
                        _selectedPhoto == null && widget.member.photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: isDarkMode
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                          )
                        : null,
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

            // First Name
            CustomText(
              text: 'first_name'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _firstNameController,
              hintText: 'first_name'.tr(),
            ),
            const SizedBox(height: 16),

            // Last Name
            CustomText(
              text: 'last_name'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _lastNameController,
              hintText: 'last_name'.tr(),
            ),
            const SizedBox(height: 16),

            // Biography
            CustomText(
              text: 'about_me'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _biographyController,
              hintText: 'tell_us_about_yourself'.tr(),
              maxLines: 4,
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
              initialValue: widget.member.phone.isNotEmpty
                  ? PhoneNumber(phoneNumber: widget.member.phone)
                  : null,
              onPhoneNumberChanged: (PhoneNumber number) {
                // Le numéro sera automatiquement mis à jour dans le controller
              },
            ),
            const SizedBox(height: 16),

            // Birth Date
            CustomText(
              text: 'birth_date'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: _birthDate != null
                          ? DateFormat('dd MMMM yyyy').format(_birthDate!)
                          : 'select_date'.tr(),
                      color: isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Portfolio
            CustomText(
              text: 'portfolio'.tr(),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _portfolioController,
              hintText: 'your_portfolio_url'.tr(),
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
              hintText: 'your_address'.tr(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
