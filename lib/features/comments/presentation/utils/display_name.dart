import '../../../../core/enums/user_role.dart';
import '../../../posts/domain/entities/member_post.dart';
import '../../data/comment.dart';

String displayNameFor(Comment c) {
  try {
    if (c.owner.role == UserRole.member) {
      final member = c.owner.owner as MemberPost;
      final first = member.firstName;
      final last = member.lastName;
      final name = ('$first $last').trim();
      return name.isEmpty ? 'User' : name;
    } else {
      final company = c.owner.owner;
      return (company?.name ?? 'Company');
    }
  } catch (_) {
    return 'User';
  }
}