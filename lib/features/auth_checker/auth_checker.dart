import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/features/posts/presentation/pages/home_page.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

import '../../core/network/websocket/config.dart';
import '../../core/services/localdb.dart';


class AuthCheckerService extends StatefulWidget {
  const AuthCheckerService({super.key});

  @override
  State<AuthCheckerService> createState() => _AuthCheckerServiceState();
}

class _AuthCheckerServiceState extends State<AuthCheckerService> {
  final db = GetIt.I<LocalDBService>();
  final socketService = GetIt.I<SocketService>();
  @override
  void initState() {
    _checkAuthAndInitSocket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
        future: db.isConnected(),
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
          if(snapshots.data == false){
            _deleteOldInfos();
            return const SplashScreen();
          }
          return HomePage();
        });
  }
  _deleteOldInfos() async {
    final db = GetIt.I<LocalDBService>();
    await db.clearAllData();
  }
  Future<void> _checkAuthAndInitSocket() async {
    final isConnected = await db.isConnected();

    if (isConnected) {
      final token = await db.getToken();
      if (token != null) {
        socketService.initSocket();
      }
    } else {
      socketService.dispose();
    }
  }
}
