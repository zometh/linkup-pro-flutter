import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/utils/services/my_logger.dart';

import '../../../../core/utils/services/localdb.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localDb = GetIt.I<LocalDBService>();

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: ()async{

          await localDb.clearAllData();
          context.go("/splash");
        }, icon: Icon(Icons.logout))],
      ),
      body: FutureBuilder(
          future: localDb.getUserInfos() /*Future.any(([
            localDb.getUserRole(),
            localDb.getUserInfos()
          ]))*/,
          builder: (_, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            if (snapshots.hasError) {
              return Center(child: Text("Error: ${snapshots.error}"),);
            }
            final data = snapshots.data as Member;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("Welcome ${data.user.firstName} ${data.user.lastName}"),),
                SizedBox(height: 20,),
                Center(child: Text("Your sector is: ${data.sector.tr()}"),),

                Expanded(child: CachedNetworkImage(
                  imageUrl: data.photoUrl ?? "",
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) => Icon(Icons.error),),

                )
              ],
            );
          }
      )
    );
  }
}
