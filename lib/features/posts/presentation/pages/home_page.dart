import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/services/localdb.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: ()async{
          final localDb = GetIt.I<LocalDBService>();
          await localDb.deleteToken();
          await localDb.deleteUserId();
          context.go("/splash");
        }, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child: Text("Bonjour"),
      ),
    );
  }
}
