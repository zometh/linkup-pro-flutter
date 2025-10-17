import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/services/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_button.dart';
import 'package:linkup_pro/core/widgets/custom_phone_picker.dart';
import 'package:linkup_pro/core/widgets/custom_popscope.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/register/presentation/providers/register_provider.dart';
import 'package:linkup_pro/main.dart';
import '../../data/entities/sector.dart';

class RegisterProfile extends ConsumerStatefulWidget {
  final Sector sector;
  const RegisterProfile({super.key, required this.sector});

  @override
  ConsumerState<RegisterProfile> createState() => _RegisterProfileState();
}

class _RegisterProfileState extends ConsumerState<RegisterProfile>
    with SingleTickerProviderStateMixin {
  XFile? _selectedImage;
  late TextEditingController _biographyController;
  late TextEditingController _phoneController;
  late TextEditingController _portfolioController;
  late AnimationController _animationController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String _fullPhoneNumber = '';

  @override
  initState() {
    super.initState();
    _biographyController = getInstance();
    _phoneController = getInstance();
    _portfolioController = getInstance();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _biographyController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool loading = ref.watch(registerProvider);
    return CustomPopscope(
      executeOnPop: () {},
      widget: Scaffold(
        body: loading
            ? const CustomProgress().animate().fadeIn(duration: 500.ms)
            : Container(
                decoration: BoxDecoration(
                  gradient: context.isDarkMode
                      ? AppGradients.scaffoldGradient
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.03),
                            Colors.white,
                          ],
                        ),
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
                                // Bouton retour
                                IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: AppColors.primary,
                                    )
                                    .animate()
                                    .fadeIn(duration: 300.ms)
                                    .slideX(begin: -0.3, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.01),

                                // Logo avec animation
                                Center(
                                  child: Hero(
                                    tag: 'app_logo',
                                    child: Image.asset(
                                      AssetsPath.logo,
                                      width: constraints.maxWidth * 0.45,
                                      height: constraints.maxHeight * 0.08,
                                    ),
                                  ),
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                  delay: 100.ms,
                                ),

                                SizedBox(height: constraints.maxHeight * 0.03),

                                // Titre avec animation
                                Center(
                                      child: Column(
                                        children: [
                                          CustomText(
                                            text: "complete_profile".tr(),
                                            fontSize:
                                                constraints.maxWidth * 0.065,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.01,
                                          ),
                                          Container(
                                            width: constraints.maxWidth * 0.15,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppGradients.primaryGradient,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 200.ms)
                                    .slideY(begin: -0.3, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.015),

                                Center(
                                  child: CustomText(
                                    text: "complete_profile_subtitle".tr(),
                                    fontSize: constraints.maxWidth * 0.038,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey[600],
                                  ),
                                ).animate().fadeIn(
                                  duration: 500.ms,
                                  delay: 300.ms,
                                ),

                                SizedBox(height: constraints.maxHeight * 0.03),

                                // Section photo de profil modernisée
                                Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: constraints.maxWidth * 0.4,
                                            height: constraints.maxWidth * 0.4,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  AppColors.primary.withValues(
                                                    alpha: 0.2,
                                                  ),
                                                  AppColors.primary.withValues(
                                                    alpha: 0.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: Card(
                                              elevation: 8,
                                              shadowColor: AppColors.primary
                                                  .withValues(alpha: 0.3),
                                              shape: const CircleBorder(),
                                              child: InkWell(
                                                onTap: _pickImage,
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient:
                                                        _selectedImage == null
                                                        ? LinearGradient(
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            colors: [
                                                              AppColors.primary
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                              AppColors.primary
                                                                  .withValues(
                                                                    alpha: 0.05,
                                                                  ),
                                                            ],
                                                          )
                                                        : null,
                                                  ),
                                                  child: _selectedImage != null
                                                      ? ClipOval(
                                                          child: Image.file(
                                                            File(
                                                              _selectedImage!
                                                                  .path,
                                                            ),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                constraints
                                                                    .maxWidth *
                                                                0.4,
                                                            height:
                                                                constraints
                                                                    .maxWidth *
                                                                0.4,
                                                          ),
                                                        )
                                                      : Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    16,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: AppColors
                                                                    .primary
                                                                    .withValues(
                                                                      alpha:
                                                                          0.15,
                                                                    ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .camera_alt_rounded,
                                                                size:
                                                                    constraints
                                                                        .maxWidth *
                                                                    0.08,
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            CustomText(
                                                              text: "add_photo"
                                                                  .tr(),
                                                              fontSize:
                                                                  constraints
                                                                      .maxWidth *
                                                                  0.032,
                                                              color: AppColors
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (_selectedImage != null)
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child:
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedImage = null;
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ).animate().scale(
                                                    duration: 300.ms,
                                                    curve: Curves.elasticOut,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 400.ms)
                                    .scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1, 1),
                                    ),

                                SizedBox(height: constraints.maxHeight * 0.03),

                                // Bio field avec animation
                                _buildSectionTitle(
                                  "bio".tr(),
                                  Icons.info_outline_rounded,
                                  constraints,
                                ).animate().fadeIn(
                                  duration: 500.ms,
                                  delay: 500.ms,
                                ),

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

                                // Phone field avec animation
                                _buildSectionTitle(
                                  "phone".tr(),
                                  Icons.phone_rounded,
                                  constraints,
                                ).animate().fadeIn(
                                  duration: 500.ms,
                                  delay: 700.ms,
                                ),

                                SizedBox(height: constraints.maxHeight * 0.015),

                                CustomPhonePicker(
                                      onPhoneNumberChanged: (PhoneNumber phone) {
                                        
                                      },
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 800.ms)
                                    .slideX(begin: 0.2, end: 0),

                                SizedBox(height: constraints.maxHeight * 0.04),

                                // Finish button avec animation
                                CustomButton(
                                      text: "finish".tr(),
                                      onPressed: _submit,
                                      height: constraints.maxHeight * 0.065,
                                      width: double.infinity,
                                    )
                                    .animate()
                                    .fadeIn(duration: 500.ms, delay: 900.ms)
                                    .slideY(begin: 0.3, end: 0),

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

  Widget _buildSectionTitle(
    String title,
    IconData icon,
    BoxConstraints constraints,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        CustomText(
          text: title,
          fontSize: constraints.maxWidth * 0.042,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;

    final int bytes = await image.length();
    const int maxBytes = 3 * 1024 * 1024; // 3 Mo

    if (bytes <= maxBytes) {
      setState(() {
        _selectedImage = image;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: CustomText(
                  color: Colors.white,
                  text: 'max_file_size'.tr(namedArgs: {'max': '3'}),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Traitement des données
      print('Biography: ${_biographyController.text}');
      print('Phone: $_fullPhoneNumber');
      print('Sector: ${widget.sector.name}');
      // Continuer avec l'enregistrement
    }
  }
}
