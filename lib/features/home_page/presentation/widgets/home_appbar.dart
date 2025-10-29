import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeAppbar extends ConsumerStatefulWidget {
  final double avaibleHeight;

  const HomeAppbar({super.key, required this.avaibleHeight});

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends ConsumerState<HomeAppbar> {
  String? imageUrl;
  final localDb = GetIt.I<LocalDBService>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserImage();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
backgroundColor: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface /*const Color(0xFF121212) : Colors.white*/,
        //elevation: 5,
        title: Padding(
          padding:  EdgeInsets.symmetric(
            vertical: widget.avaibleHeight * 0.3,
            horizontal: 0
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: widget.avaibleHeight * 0.3,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _imageProvider(),
                  ),
                  SizedBox(width: widget.avaibleHeight * 0.2),
                  Expanded(child: CustomTextField(controller: TextEditingController(), hintText: "ss")),
                  IconButton(
                    onPressed: () {
                      ref.read(authProvider).logout();
                    },
                    icon: const Icon(Icons.logout),
                  )
                ],

          ),
        ),
        centerTitle: true,

    );
  }

  ImageProvider<Object> _imageProvider() {
    // Defensive: handle null, empty, http(s) urls and local file paths.
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return const AssetImage(AssetsPath.defaultProfile);
    }

    final url = imageUrl!.trim();

    // network image
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    }

    // file:// URI
    if (url.startsWith('file://')) {
      final path = url.replaceFirst('file://', '');
      return FileImage(File(path));
    }

    // plain absolute/local path
    try {
      final f = File(url);
      if (f.existsSync()) return FileImage(f);
    } catch (_) {}

    // fallback to asset
    return const AssetImage(AssetsPath.defaultProfile);
  }

  _fetchUserImage() async {
    final img = await localDb.getUserProfileImage();
    setState(() {
      imageUrl = img;
    });
  }
}
