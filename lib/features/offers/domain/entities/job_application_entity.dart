import 'package:linkup_pro/features/offers/domain/entities/job_offer_entity.dart';
import 'package:linkup_pro/features/offers/domain/entities/applicant_preview.dart';

/// Status of a job application
enum ApplicationStatus {
  pending,
  accepted,
  refused,
  canceled,
  inReview;

  static ApplicationStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return ApplicationStatus.pending;
      case 'ACCEPTED':
        return ApplicationStatus.accepted;
      case 'REFUSED':
        return ApplicationStatus.refused;
      case 'CANCELED':
        return ApplicationStatus.canceled;
      case 'IN_REVIEW':
        return ApplicationStatus.inReview;
      default:
        return ApplicationStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'En attente';
      case ApplicationStatus.accepted:
        return 'Acceptée';
      case ApplicationStatus.refused:
        return 'Refusée';
      case ApplicationStatus.canceled:
        return 'Annulée';
      case ApplicationStatus.inReview:
        return 'En cours d\'examen';
    }
  }
}

/// Entity representing a job application
class JobApplicationEntity {
  final String id;
  final String jobOfferId;
  final String memberId;
  final String statusId;
  final ApplicationStatus status;
  final String? resumeUrl;
  final String? coverLetter;
  final String? responseMessage;
  final DateTime applicationDate;
  final DateTime? responseDate;
  final JobOfferEntity? jobOffer;
  final ApplicantPreview? applicant;

  const JobApplicationEntity({
    required this.id,
    required this.jobOfferId,
    required this.memberId,
    required this.statusId,
    required this.status,
    this.resumeUrl,
    this.coverLetter,
    this.responseMessage,
    required this.applicationDate,
    this.responseDate,
    this.jobOffer,
    this.applicant,
  });

  factory JobApplicationEntity.fromJson(Map<String, dynamic> json) {

    // Handle jobOfferId - can be direct field or nested in jobOffer
    final jobOfferId = json['jobOfferId'] as String? ??
        (json['jobOffer'] != null ? json['jobOffer']['id'] as String? : null) ?? '';

    // Handle memberId - can be direct field or nested in applicant
    final memberId = json['memberId'] as String? ??
        (json['applicant'] != null ? json['applicant']['id'] as String? : null) ?? '';

    // Handle statusId - can be direct field or nested in status
    final statusId = json['statusId'] as String? ??
        (json['status'] != null ? json['status']['id'] as String? : null) ?? '';

    // Handle status value - can be 'value' or 'name' depending on API response
    final statusValue = json['status']?['value'] as String? ??
        json['status']?['name'] as String? ?? 'PENDING';

    return JobApplicationEntity(
      id: json['id'] as String,
      jobOfferId: jobOfferId,
      memberId: memberId,
      statusId: statusId,
      status: ApplicationStatus.fromString(statusValue),
      resumeUrl: json['resumeUrl'] as String?,
      coverLetter: json['coverLetter'] as String?,
      responseMessage: json['responseMessage'] as String?,
      applicationDate: DateTime.parse(json['applicationDate'] as String),
      responseDate: json['responseDate'] != null
          ? DateTime.parse(json['responseDate'] as String)
          : null,
      jobOffer: json['jobOffer'] != null
          ? JobOfferEntity.fromJson(json['jobOffer'] as Map<String, dynamic>)
          : null,
      applicant: json['applicant'] != null
          ? ApplicantPreview.fromJson(json['applicant'] as Map<String, dynamic>)
          : (json['member'] != null
              ? ApplicantPreview.fromJson(json['member'] as Map<String, dynamic>)
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobOfferId': jobOfferId,
      'memberId': memberId,
      'statusId': statusId,
      'resumeUrl': resumeUrl,
      'coverLetter': coverLetter,
      'responseMessage': responseMessage,
      'applicationDate': applicationDate.toIso8601String(),
      'responseDate': responseDate?.toIso8601String(),
    };
  }

  JobApplicationEntity copyWith({
    String? id,
    String? jobOfferId,
    String? memberId,
    String? statusId,
    ApplicationStatus? status,
    String? resumeUrl,
    String? coverLetter,
    String? responseMessage,
    DateTime? applicationDate,
    DateTime? responseDate,
    JobOfferEntity? jobOffer,
    ApplicantPreview? applicant,
  }) {
    return JobApplicationEntity(
      id: id ?? this.id,
      jobOfferId: jobOfferId ?? this.jobOfferId,
      memberId: memberId ?? this.memberId,
      statusId: statusId ?? this.statusId,
      status: status ?? this.status,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      coverLetter: coverLetter ?? this.coverLetter,
      responseMessage: responseMessage ?? this.responseMessage,
      applicationDate: applicationDate ?? this.applicationDate,
      responseDate: responseDate ?? this.responseDate,
      jobOffer: jobOffer ?? this.jobOffer,
      applicant: applicant ?? this.applicant,
    );
  }

  /// Check if the application is still pending
  bool get isPending => status == ApplicationStatus.pending;

  /// Check if the application is accepted
  bool get isAccepted => status == ApplicationStatus.accepted;

  /// Check if the application can be canceled
  bool get canCancel =>
      status == ApplicationStatus.pending ||
      status == ApplicationStatus.inReview;

  @override
  String toString() {
    return 'JobApplicationEntity(id: $id, jobOfferId: $jobOfferId, status: $status)';
  }
}
