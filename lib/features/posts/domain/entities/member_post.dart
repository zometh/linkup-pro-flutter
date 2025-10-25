class MemberPost {
  final String firstName;
  final String lastName;
  final String? photo;
  const MemberPost({
    required this.firstName,
    required this.lastName,
    this.photo,
  });
  factory MemberPost.fromJson(Map<String, dynamic> json) {
    return MemberPost(
      firstName: json['firstName'],
      lastName: json['lastName'],
      photo: json['photo'],
    );
  }
}
