import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/core/widgets/custom_toast.dart';
import 'package:toastification/toastification.dart';

class ProfilePicker extends StatelessWidget {
  final File? imageFile;
  final BoxConstraints constraints;
  final Function()? onImageRemove;
  final Function(File)? onImageSelected;
  const ProfilePicker({
    super.key,
    required this.imageFile,
    required this.constraints,
    this.onImageSelected,
    this.onImageRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Stack(
            children: [
              Container(
                width: constraints.maxWidth * 0.4,
                height: constraints.maxWidth * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: Card(
                  elevation: 8,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _pickImage(context),
                    borderRadius: BorderRadius.circular(1000),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: imageFile == null
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.1),
                                  AppColors.primary.withValues(alpha: 0.05),
                                ],
                              )
                            : null,
                      ),
                      child: imageFile != null
                          ? ClipOval(
                              child: Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.cover,
                                width: constraints.maxWidth * 0.4,
                                height: constraints.maxWidth * 0.4,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: constraints.maxWidth * 0.08,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomText(
                                  text: "add_photo".tr(),
                                  fontSize: constraints.maxWidth * 0.02,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              if (imageFile != null)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        onImageRemove?.call();                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
                ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) return;

    final int bytes = await image.length();
    const int maxBytes = 3 * 1024 * 1024; // 3 Mo

    if (bytes <= maxBytes) {
     onImageSelected?.call(File(image.path));
      /*setState(() {
        _imageFile = File(image.path);
      });*/
    } else {
      showToast(description: 'max_file_size'.tr(namedArgs: {'max': '3'}),
      type: ToastificationType.error
      );

    }
  }
}
