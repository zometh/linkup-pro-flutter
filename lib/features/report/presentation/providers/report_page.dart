import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/report/domain/entity/report.dart';
import 'package:linkup_pro/features/report/domain/implementations/report_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'report_page.g.dart';
@Riverpod()
class ReportPageProvider extends _$ReportPageProvider {
  final reportImplement = GetIt.I<ReportRepositoryImplement>();
  @override
  bool build() => false;

  Future<Map<String, dynamic>?> createReport(Report reportData) async {
    Future.microtask(() => state = true);
    try {
      final response = await reportImplement.createReport(reportData);
      final result = response.fold(
        (failure) {
          return null;
        },
        (data) {
          return data;
        },
      );
      Future.microtask(() => state = false);
      return result;

    }catch (e) {
      Future.microtask(() => state = false);
      rethrow;
    }
  }

}