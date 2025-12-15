import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/profile_jobs/data/entity/job_entity.dart';
import 'package:linkup_pro/features/profile_jobs/data/models/job_model.dart';
import 'package:linkup_pro/features/profile_jobs/data/repos/job_repository.dart';
import 'package:linkup_pro/features/profile_jobs/data/repos_implements/job_repository_impl.dart';

class ProfileJobsState {
  final List<JobModel> jobs;
  final List<CompanyInfo> searchedCompanies;
  final bool isLoading;
  final bool isSearching;
  final String? error;

  ProfileJobsState({
    this.jobs = const [],
    this.searchedCompanies = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.error,
  });

  ProfileJobsState copyWith({
    List<JobModel>? jobs,
    List<CompanyInfo>? searchedCompanies,
    bool? isLoading,
    bool? isSearching,
    String? error,
  }) {
    return ProfileJobsState(
      jobs: jobs ?? this.jobs,
      searchedCompanies: searchedCompanies ?? this.searchedCompanies,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }
}

class ProfileJobsNotifier extends Notifier<ProfileJobsState> {
  final JobRepository _repository = JobRepositoryImpl();

  @override
  ProfileJobsState build() {
    return ProfileJobsState();
  }

  Future<void> loadMyJobs() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final jobs = await _repository.getMyJobs();
      state = state.copyWith(jobs: jobs, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(jobs: [], isLoading: false, error: e.toString());
    }
  }

  Future<void> loadJobs(String profileId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final jobs = await _repository.getJobsByProfile(profileId);
      state = state.copyWith(jobs: jobs, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(jobs: [], isLoading: false, error: e.toString());
    }
  }

  Future<bool> addJob(JobEntity job) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newJob = await _repository.createJob(job.toJson());
      final updatedJobs = [...state.jobs, newJob];
      state = state.copyWith(jobs: updatedJobs, isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateJob(String id, JobEntity job) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedJob = await _repository.updateJob(id, job.toJson());
      final updatedJobs = state.jobs.map((j) {
        return j.id == id ? updatedJob : j;
      }).toList();
      state = state.copyWith(jobs: updatedJobs, isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteJob(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteJob(id);
      final updatedJobs = state.jobs.where((job) => job.id != id).toList();
      state = state.copyWith(jobs: updatedJobs, isLoading: false, error: null);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> searchCompanies(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchedCompanies: []);
      return;
    }

    state = state.copyWith(isSearching: true);

    try {
      final companies = await _repository.searchCompanies(query, limit: 10);
      state = state.copyWith(searchedCompanies: companies, isSearching: false);
    } catch (e) {
      state = state.copyWith(
        searchedCompanies: [],
        isSearching: false,
        error: e.toString(),
      );
    }
  }

  void clearCompanySearch() {
    state = state.copyWith(searchedCompanies: []);
  }
}

final profileJobsProvider =
    NotifierProvider<ProfileJobsNotifier, ProfileJobsState>(
      () => ProfileJobsNotifier(),
    );
