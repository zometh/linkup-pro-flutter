import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/features/posts/presentation/pages/home_page.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

import '../../core/utils/services/localdb.dart';

class AuthCheckerService extends StatelessWidget {
  const AuthCheckerService({super.key});

  @override
  Widget build(BuildContext context) {
    final db = GetIt.I<LocalDBService>();
    return FutureBuilder(
        future: db.getToken(),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return const CustomProgress();
          }
          if(snapshots.error != null){
            return const SplashScreen();
          }
          if(snapshots.data == null){
            return const SplashScreen();
          }
          
          return HomePage();
        });
  }
}
