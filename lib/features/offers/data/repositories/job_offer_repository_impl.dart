import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer_company.dart';
import 'package:linkup_pro/features/offers/domain/entities/search_offers_result.dart';
import 'package:linkup_pro/features/offers/domain/repositories/job_repository.dart';

/// Implementation of JobOfferRepository
class JobOfferRepositoryImpl implements JobOfferRepository {
  final _apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, List<JobOfferEntity>>> getTargetedOffers({
    int? page,
    int? limit,
    String? employmentTypeId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (employmentTypeId != null) {
        queryParams['employmentTypeId'] = employmentTypeId;
      }

      final response = await _apiClient.get(
        '/job-offers/targeted',
        queryParams: queryParams,
      );

      final offers = response
          .map((json) => JobOfferEntity.fromJson(json))
          .toList();

      return Right(offers);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SearchOffersResult>> searchOffers({
    required String query,
    String? employmentTypeId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        'page': page,
        'limit': limit,
      };
      if (employmentTypeId != null) {
        queryParams['employmentTypeId'] = employmentTypeId;
      }

      final response = await _apiClient.getOne(
        '/job-offers/search',
        queryParams: queryParams,
      );

      final offers = (response['offers'] as List)
          .map((json) => JobOfferEntity.fromJson(json as Map<String, dynamic>))
          .toList();

      return Right(
        SearchOffersResult(
          offers: offers,
          total: response['total'] as int? ?? 0,
          page: response['page'] as int? ?? 1,
          limit: response['limit'] as int? ?? 20,
          totalPages: response['totalPages'] as int? ?? 0,
        ),
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobOfferEntity>> getJobOfferById(String id) async {
    try {
      final response = await _apiClient.getOne('/job-offers/$id');

      if (response.isEmpty) {
        return Left(Failure('Offre non trouvée'));
      }

      return Right(JobOfferEntity.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobOfferCompany>>> getCompanyOffers({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get(
        '/job-offers/company',
        queryParams: queryParams,
      );
      final offers = response
          .map((json) => JobOfferCompany.fromJson(json))
          .toList();

      return Right(offers);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobOfferCompany>> createJobOffer({
    required String title,
    required String description,
    double? salary,
    required String employmentTypeId,
    DateTime? expiryDate,
    List<Map<String, dynamic>>? requiredSkills,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description,
        'employmentTypeId': employmentTypeId,
      };

      if (salary != null) data['salary'] = salary;
      if (expiryDate != null) {
        data['expiryDate'] = expiryDate.toIso8601String();
      }
      if (requiredSkills != null && requiredSkills.isNotEmpty) {
        data['requiredSkills'] = requiredSkills;
      }

      final response = await _apiClient.post('/job-offers', data: data);

      if (response.isEmpty) {
        return Left(Failure('Erreur lors de la création'));
      }

      return Right(JobOfferCompany.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobOfferCompany>> updateJobOffer({
    required String id,
    String? title,
    String? description,
    double? salary,
    String? employmentTypeId,
    DateTime? expiryDate,
    bool? isActive,
    List<Map<String, dynamic>>? requiredSkills,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (salary != null) data['salary'] = salary;
      if (employmentTypeId != null) {
        data['employmentTypeId'] = employmentTypeId;
      }
      if (expiryDate != null) {
        data['expiryDate'] = expiryDate.toIso8601String();
      }
      if (isActive != null) data['isActive'] = isActive;
      if (requiredSkills != null) {
        data['requiredSkills'] = requiredSkills;
      }

      final response = await _apiClient.put('/job-offers/$id', data);

      if (response.isEmpty) {
        return Left(Failure('Erreur lors de la mise à jour'));
      }

      return Right(JobOfferCompany.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJobOffer(String id) async {
    try {
      await _apiClient.delete('/job-offers/$id');
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
