enum UserRole { admin, member, entreprise }

UserRole userRoleFromString(String role) {
  switch (role.toUpperCase()) {
    case 'ADMIN':
      return UserRole.admin;
    case 'MEMBER':
      return UserRole.member;
    case 'ENTREPRISE':
      return UserRole.entreprise;
    default:
      throw ArgumentError('Unknown user role: $role');
  }
}
