import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/features/profile_jobs/data/models/job_model.dart';
import 'package:linkup_pro/features/profile_jobs/data/repos/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final ApiClient apiClient = GetIt.instance.get<ApiClient>();

  @override
  Future<List<JobModel>> getMyJobs() async {
    try {
      final response = await apiClient.get('/jobs/my-jobs');
      return (response as List)
          .map((job) => JobModel.fromJson(job as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get jobs: $e');
    }
  }

  @override
  Future<List<JobModel>> getJobsByProfile(String profileId) async {
    try {
      final response = await apiClient.get('/jobs/profile/$profileId');
      return (response as List)
          .map((job) => JobModel.fromJson(job as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get jobs: $e');
    }
  }

  @override
  Future<JobModel> createJob(Map<String, dynamic> jobData) async {
    try {
      final response = await apiClient.post('/jobs', data: jobData);
      return JobModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to create job: $e');
    }
  }

  @override
  Future<JobModel> updateJob(String id, Map<String, dynamic> jobData) async {
    try {
      final response = await apiClient.put('/jobs/$id', jobData);
      return JobModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update job: $e');
    }
  }

  @override
  Future<void> deleteJob(String id) async {
    try {
      await apiClient.delete('/jobs/$id');
    } catch (e) {
      throw Exception('Failed to delete job: $e');
    }
  }

  @override
  Future<List<CompanyInfo>> searchCompanies(
    String query, {
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '/jobs/search-companies',
        queryParams: {'query': query, 'limit': limit.toString()},
      );
      return (response as List)
          .map(
            (company) => CompanyInfo.fromJson(company as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search companies: $e');
    }
  }
}
