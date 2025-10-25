import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/entities/company.dart';
import 'package:linkup_pro/core/entities/member.dart';
import 'package:linkup_pro/core/enums/user_role.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/auth_checker/auth_checker.dart';
import 'package:linkup_pro/features/posts/presentation/pages/posts_view.dart';

import '../../../../core/services/localdb.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localDb = GetIt.I<LocalDBService>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await localDb.clearAllData();
              //SocketService().dispose();
              // context.go("/");
              final route = MaterialPageRoute(
                builder: (_) => const AuthCheckerService(),
              );
              Navigator.of(context).push(route);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PostsView(),
    );
  }

  FutureBuilder<List<dynamic>> showConnectedUserInfos(LocalDBService localDb) {
    return FutureBuilder(
      future: Future.wait(([localDb.getUserRole(), localDb.getUserInfos()])),
      builder: (_, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshots.hasError) {
          return Center(child: Text("Error: ${snapshots.error}"));
        }
        final role = snapshots.data![0] as UserRole;
        if (role == UserRole.member) {
          final member = snapshots.data![1] as Member;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: member.photoUrl ?? '',
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(radius: 50, backgroundImage: imageProvider),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(height: 20),
                CustomText(
                  text:
                      "WELCOME ${member.user.firstName} ${member.user.lastName}",
                ),
              ],
            ),
          );
        } else {
          final company = snapshots.data![1] as Company;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: company.logo,
                  imageBuilder: (context, imageProvider) =>
                      CircleAvatar(radius: 50, backgroundImage: imageProvider),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(height: 20),
                CustomText(text: "WELCOME ${company.name}"),
              ],
            ),
          );
        }
      },
    );
  }
}
