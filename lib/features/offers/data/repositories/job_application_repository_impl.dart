import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/domain/repositories/job_repository.dart';

/// Implementation of JobApplicationRepository
class JobApplicationRepositoryImpl implements JobApplicationRepository {
  final _apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, JobApplicationEntity>> applyToJob({
    required String jobOfferId,
    String? resumeUrl,
    String? coverLetter,
  }) async {
    try {
      final data = <String, dynamic>{'jobOfferId': jobOfferId};

      if (resumeUrl != null && resumeUrl.isNotEmpty) {
        data['resumeUrl'] = resumeUrl;
      }
      if (coverLetter != null && coverLetter.isNotEmpty) {
        data['coverLetter'] = coverLetter;
      }

      final response = await _apiClient.post('/job-applications', data: data);

      if (response.isEmpty) {
        return Left(Failure('Erreur lors de la candidature'));
      }

      return Right(JobApplicationEntity.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobApplicationEntity>>> getMemberApplications({
    int? page,
    int? limit,
    String? statusId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (statusId != null) queryParams['statusId'] = statusId;

      final response = await _apiClient.get(
        '/job-applications/member',
        queryParams: queryParams,
      );

      final applications = response
          .map((json) => JobApplicationEntity.fromJson(json))
          .toList();

      return Right(applications);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobApplicationEntity>>> getCompanyApplications({
    int? page,
    int? limit,
    String? jobOfferId,
    String? statusId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (jobOfferId != null) queryParams['jobOfferId'] = jobOfferId;
      if (statusId != null) queryParams['statusId'] = statusId;

      final response = await _apiClient.get(
        '/job-applications/company',
        queryParams: queryParams,
      );

      final applications = response
          .map((json) => JobApplicationEntity.fromJson(json))
          .toList();

      return Right(applications);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobApplicationEntity>> updateApplicationStatus({
    required String applicationId,
    required String statusId,
    String? responseMessage,
  }) async {
    try {
      final data = <String, dynamic>{'statusId': statusId};

      if (responseMessage != null && responseMessage.isNotEmpty) {
        data['responseMessage'] = responseMessage;
      }

      final response = await _apiClient.put(
        '/job-applications/$applicationId/status',
        data,
      );

      if (response.isEmpty) {
        return Left(Failure('Erreur lors de la mise à jour'));
      }

      return Right(JobApplicationEntity.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApplication(String applicationId) async {
    try {
      await _apiClient.delete('/job-applications/$applicationId');
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
