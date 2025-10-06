import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/custom_toast.dart';
import 'package:linkup_pro/features/auth/data/auth_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/utils/services/my_logger.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final _authRepositoryImplements = GetIt.I<AuthRepositoryImplement>();
  final _logger = GetIt.I<MyLogger>();
   bool isLoading = false;
  String errorMessage = '';

  @override
  bool build() => isLoading;
  Future<void> signIn(BuildContext context, String credential, String password) async{
    isLoading = true;
    final response = await _authRepositoryImplements.signIn(credential, password);
    response.fold((failure) {
      showToast( description: "SignIn Error: ${failure.message}");
      _logger.log('SignIn Error: ${failure.message}', type: LogType.error, error: failure);
      isLoading = false;
    }, (token) {
      _logger.log('SignIn Success: $token', type: LogType.info);
      isLoading = false;
    });
  }
}
