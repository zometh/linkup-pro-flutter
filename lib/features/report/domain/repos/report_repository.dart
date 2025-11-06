import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/report/domain/entity/report.dart';

import '../../../../core/utils/types/error_api_type.dart';

abstract class ReportRepository {
  Future<Either<Failure, Map<String, dynamic>>> createReport(Report report);
}