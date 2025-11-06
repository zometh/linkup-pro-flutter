import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/assets_path.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../posts_actions/presentation/pages/post_action_page.dart';

class HomeAppbar extends ConsumerStatefulWidget {
  final double avaibleHeight;

  const HomeAppbar({super.key, required this.avaibleHeight});

  @override
  ConsumerState<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends ConsumerState<HomeAppbar> {
  final localDb = GetIt.I<LocalDBService>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(

backgroundColor: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        //elevation: 5,
        title: Container(
          width: double.infinity,
          padding:  EdgeInsets.symmetric(
            vertical: widget.avaibleHeight * 0.2,
            horizontal: 0
          ),
          child: Row(
          //  mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Image.asset(  AssetsPath.logo,

                    height: widget.avaibleHeight * 0.6,
                  ),
                  ElevatedButton.icon(
                    onPressed: (){
                      MyNavigator(context).navigateTo(const PostActionPage());
                    },
                    label: CustomText(text: "publish".tr()), icon: Icon(FontAwesomeIcons.plus))

                ],

          ),

        ),
        centerTitle: true,

    );
  }


}
