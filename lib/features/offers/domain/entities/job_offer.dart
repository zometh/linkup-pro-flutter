class JobOffer {
  final String id;
  final String title;
  final String companyName;
  final String companyLogo;
  final String location;
  final String type; // Full-time, Part-time, Remote, Hybrid
  final String salary;
  final String description;
  final List<String> requirements;
  final List<String> tags;
  final DateTime postedAt;
  final bool isSaved;
  final bool isRecommended;

  JobOffer({
    required this.id,
    required this.title,
    required this.companyName,
    required this.companyLogo,
    required this.location,
    required this.type,
    required this.salary,
    required this.description,
    required this.requirements,
    required this.tags,
    required this.postedAt,
    this.isSaved = false,
    this.isRecommended = false,
  });

  JobOffer copyWith({bool? isSaved, bool? isRecommended}) {
    return JobOffer(
      id: id,
      title: title,
      companyName: companyName,
      companyLogo: companyLogo,
      location: location,
      type: type,
      salary: salary,
      description: description,
      requirements: requirements,
      tags: tags,
      postedAt: postedAt,
      isSaved: isSaved ?? this.isSaved,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }
}
