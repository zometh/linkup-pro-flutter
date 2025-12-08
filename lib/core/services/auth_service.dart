

import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';

class AuthService {
  final db = GetIt.I<LocalDBService>();
  Future<void> logOut() async{
    await db.clearAllData();

  }
}