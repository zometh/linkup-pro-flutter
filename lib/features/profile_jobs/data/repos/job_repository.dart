import 'package:linkup_pro/features/profile_jobs/data/models/job_model.dart';

abstract class JobRepository {
  Future<List<JobModel>> getMyJobs(String userId);
  Future<List<JobModel>> getJobsByProfile(String profileId);
  Future<JobModel> createJob(Map<String, dynamic> jobData);
  Future<JobModel> updateJob(String id, Map<String, dynamic> jobData);
  Future<void> deleteJob(String id);
  Future<List<CompanyInfo>> searchCompanies(String query, {int limit = 10});
}
