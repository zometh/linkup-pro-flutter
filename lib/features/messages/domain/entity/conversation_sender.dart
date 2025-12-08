class ConversationSender {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final ConversationProfile? profile;
  final ConversationCompany? companies;
  final String displayName;

  ConversationSender({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.profile,
    this.companies,
    required this.displayName,
  });

  factory ConversationSender.fromJson(Map<String, dynamic> json) {
    return ConversationSender(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profile: json['profile'] != null
          ? ConversationProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      companies: json['companies'] != null
          ? ConversationCompany.fromJson(json['companies'] as Map<String, dynamic>)
          : null,
      displayName: json['displayName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'profile': profile?.toJson(),
      'companies': companies?.toJson(),
      'displayName': displayName,
    };
  }
}

class ConversationProfile {
  final String photo;

  ConversationProfile({
    required this.photo,
  });

  factory ConversationProfile.fromJson(Map<String, dynamic> json) {
    return ConversationProfile(
      photo: json['photo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
    };
  }
}

class ConversationCompany {
  final String name;
  final String logo;

  ConversationCompany({
    required this.name,
    required this.logo,
  });

  factory ConversationCompany.fromJson(Map<String, dynamic> json) {
    return ConversationCompany(
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
    };
  }
}
