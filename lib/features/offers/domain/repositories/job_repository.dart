import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:linkup_pro/features/offers/domain/entities/job_offer_company.dart';
import 'package:linkup_pro/features/offers/domain/entities/search_offers_result.dart';

/// Repository interface for job offers
abstract class JobOfferRepository {
  /// Get targeted job offers for the current member
  Future<Either<Failure, List<JobOfferEntity>>> getTargetedOffers({
    int? page,
    int? limit,
    String? employmentTypeId,
  });

  /// Search job offers
  Future<Either<Failure, SearchOffersResult>> searchOffers({
    required String query,
    String? employmentTypeId,
    int page,
    int limit,
  });

  /// Get a single job offer by ID
  Future<Either<Failure, JobOfferEntity>> getJobOfferById(String id);

  /// Get job offers created by a company
  Future<Either<Failure, List<JobOfferCompany>>> getCompanyOffers({
    int? page,
    int? limit,
  });

  /// Create a new job offer (company only)
  Future<Either<Failure, JobOfferCompany>> createJobOffer({
    required String title,
    required String description,
    double? salary,
    required String employmentTypeId,
    DateTime? expiryDate,
    List<Map<String, dynamic>>? requiredSkills,
  });

  /// Update a job offer (company only)
  Future<Either<Failure, JobOfferCompany>> updateJobOffer({
    required String id,
    String? title,
    String? description,
    double? salary,
    String? employmentTypeId,
    DateTime? expiryDate,
    bool? isActive,
    List<Map<String, dynamic>>? requiredSkills,
  });

  /// Delete a job offer (company only)
  Future<Either<Failure, void>> deleteJobOffer(String id);
}

/// Repository interface for job applications
abstract class JobApplicationRepository {
  /// Apply to a job offer (member only)
  Future<Either<Failure, JobApplicationEntity>> applyToJob({
    required String jobOfferId,
    String? resumeUrl,
    String? coverLetter,
  });

  /// Get member's applications
  Future<Either<Failure, List<JobApplicationEntity>>> getMemberApplications({
    int? page,
    int? limit,
    String? statusId,
  });

  /// Get applications for company's job offers
  Future<Either<Failure, List<JobApplicationEntity>>> getCompanyApplications({
    int? page,
    int? limit,
    String? jobOfferId,
    String? statusId,
  });

  /// Update application status (company only)
  Future<Either<Failure, JobApplicationEntity>> updateApplicationStatus({
    required String applicationId,
    required String statusId,
    String? responseMessage,
  });

  /// Delete/cancel an application (member only)
  Future<Either<Failure, void>> deleteApplication(String applicationId);
}

/// Failure class for error handling
class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
