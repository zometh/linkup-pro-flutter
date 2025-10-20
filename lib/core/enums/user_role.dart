enum UserRole {
  admin,
  member,
  company,
}

UserRole userRoleFromString(String role) {
  switch (role.toUpperCase()) {
    case 'ADMIN':
      return UserRole.admin;
    case 'MEMBER':
      return UserRole.member;
    case 'ENTREPRISE':
      return UserRole.company;
    default:
      throw ArgumentError('Unknown user role: $role');
  }
}