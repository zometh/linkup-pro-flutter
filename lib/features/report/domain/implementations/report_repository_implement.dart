
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/report/domain/entity/report.dart';
import 'package:linkup_pro/features/report/domain/repos/report_repository.dart';

import '../../../../core/network/api/api_client.dart';

class ReportRepositoryImplement implements ReportRepository{
  final _apiClient = GetIt.I<ApiClient>();
  @override
  Future<Either<Failure, Map<String, dynamic>>> createReport(Report report)async {
    try{
      final response =  await _apiClient.post("/reports", data: report.toMap());
      return Right(response);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }
  // Implementation details will go here
}