import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/offers/data/repositories/job_application_repository_impl.dart';
import 'package:linkup_pro/features/offers/domain/entities/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'job_application_provider.g.dart';

/// State class for job applications list
class JobApplicationsState {
  final List<JobApplicationEntity> applications;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  const JobApplicationsState({
    this.applications = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  JobApplicationsState copyWith({
    List<JobApplicationEntity>? applications,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return JobApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  List<JobApplicationEntity> get pendingApplications =>
      applications.where((a) => a.isPending).toList();

  List<JobApplicationEntity> get acceptedApplications =>
      applications.where((a) => a.isAccepted).toList();
}

/// Provider for member's job applications
@Riverpod(keepAlive: true)
class MemberApplications extends _$MemberApplications {
  final _repository = GetIt.I<JobApplicationRepositoryImpl>();

  @override
  JobApplicationsState build() {
    return const JobApplicationsState();
  }

  /// Fetch member's applications
  Future<void> fetchApplications({String? statusId}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getMemberApplications(
      page: 1,
      limit: 20,
      statusId: statusId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (applications) => state = state.copyWith(
        applications: applications,
        isLoading: false,
        currentPage: 1,
        hasMore: applications.length >= 20,
      ),
    );
  }

  /// Load more applications
  Future<void> loadMore({String? statusId}) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.getMemberApplications(
      page: nextPage,
      limit: 20,
      statusId: statusId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newApplications) => state = state.copyWith(
        applications: [...state.applications, ...newApplications],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newApplications.length >= 20,
      ),
    );
  }

  /// Apply to a job
  Future<JobApplicationEntity?> applyToJob({
    required String jobOfferId,
    String? resumeUrl,
    String? coverLetter,
  }) async {
    final result = await _repository.applyToJob(
      jobOfferId: jobOfferId,
      resumeUrl: resumeUrl,
      coverLetter: coverLetter,
    );

    return result.fold((failure) => null, (application) {
      state = state.copyWith(
        applications: [application, ...state.applications],
      );
      return application;
    });
  }

  /// Cancel/delete an application
  Future<bool> deleteApplication(String applicationId) async {
    final result = await _repository.deleteApplication(applicationId);

    return result.fold((failure) => false, (_) {
      state = state.copyWith(
        applications: state.applications
            .where((a) => a.id != applicationId)
            .toList(),
      );
      return true;
    });
  }

  /// Update application status (from WebSocket)
  void updateApplicationStatus(JobApplicationEntity updatedApplication) {
    final index = state.applications.indexWhere(
      (a) => a.id == updatedApplication.id,
    );
    if (index != -1) {
      final newApplications = List<JobApplicationEntity>.from(
        state.applications,
      );
      newApplications[index] = updatedApplication;
      state = state.copyWith(applications: newApplications);
    }
  }

  /// Remove an application (from WebSocket)
  void removeApplication(String applicationId) {
    state = state.copyWith(
      applications: state.applications
          .where((a) => a.id != applicationId)
          .toList(),
    );
  }

  void clear() {
    state = const JobApplicationsState();
  }
}

/// Provider for company's received applications
@Riverpod(keepAlive: true)
class CompanyApplications extends _$CompanyApplications {
  final _repository = GetIt.I<JobApplicationRepositoryImpl>();

  @override
  JobApplicationsState build() {
    return const JobApplicationsState();
  }

  /// Fetch applications for company's offers
  Future<void> fetchApplications({String? jobOfferId, String? statusId}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getCompanyApplications(
      page: 1,
      limit: 20,
      jobOfferId: jobOfferId,
      statusId: statusId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (applications) => state = state.copyWith(
        applications: applications,
        isLoading: false,
        currentPage: 1,
        hasMore: applications.length >= 20,
      ),
    );
  }

  /// Load more applications
  Future<void> loadMore({String? jobOfferId, String? statusId}) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final nextPage = state.currentPage + 1;
    final result = await _repository.getCompanyApplications(
      page: nextPage,
      limit: 20,
      jobOfferId: jobOfferId,
      statusId: statusId,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (newApplications) => state = state.copyWith(
        applications: [...state.applications, ...newApplications],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newApplications.length >= 20,
      ),
    );
  }

  /// Update application status (accept, refuse, etc.)
  Future<bool> updateStatus({
    required String applicationId,
    required String statusId,
    String? responseMessage,
  }) async {
    final result = await _repository.updateApplicationStatus(
      applicationId: applicationId,
      statusId: statusId,
      responseMessage: responseMessage,
    );

    return result.fold((failure) => false, (updatedApplication) {
      final index = state.applications.indexWhere((a) => a.id == applicationId);
      if (index != -1) {
        final newApplications = List<JobApplicationEntity>.from(
          state.applications,
        );
        newApplications[index] = updatedApplication;
        state = state.copyWith(applications: newApplications);
      }
      return true;
    });
  }

  /// Add new application (from WebSocket)
  void addApplication(JobApplicationEntity application) {
    state = state.copyWith(applications: [application, ...state.applications]);
  }

  /// Remove an application
  void removeApplication(String applicationId) {
    state = state.copyWith(
      applications: state.applications
          .where((a) => a.id != applicationId)
          .toList(),
    );
  }

  void clear() {
    state = const JobApplicationsState();
  }
}

/// Provider for applying to a job (handles loading state)
@riverpod
class ApplyToJobNotifier extends _$ApplyToJobNotifier {
  @override
  bool build() => false;

  Future<bool> apply({
    required String jobOfferId,
    String? resumeUrl,
    String? coverLetter,
  }) async {
    state = true; // Loading

    final memberApplications = ref.read(memberApplicationsProvider.notifier);
    final result = await memberApplications.applyToJob(
      jobOfferId: jobOfferId,
      resumeUrl: resumeUrl,
      coverLetter: coverLetter,
    );

    state = false;
    return result != null;
  }
}
