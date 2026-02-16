/// Preview of an applicant for job applications
class ApplicantPreview {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String? title;
  final String? email;
  final int? yearsOfExperience;

  const ApplicantPreview({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.title,
    this.email,
    this.yearsOfExperience,
  });

  factory ApplicantPreview.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return ApplicantPreview(
      id: json['id'] as String,
      firstName:
          user?['firstName'] as String? ?? json['firstName'] as String? ?? '',
      lastName:
          user?['lastName'] as String? ?? json['lastName'] as String? ?? '',
      profilePicture:
          user?['profilePicture'] as String? ??
          json['profilePicture'] as String? ??
          json['photo'] as String?,
      title: json['title'] as String?,
      email: user?['email'] as String? ?? json['email'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'title': title,
      'email': email,
      'yearsOfExperience': yearsOfExperience,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() => 'ApplicantPreview(id: $id, name: $fullName)';
}
