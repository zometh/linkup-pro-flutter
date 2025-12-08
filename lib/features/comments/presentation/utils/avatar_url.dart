import '../../../../core/enums/user_role.dart';
import '../../../posts/domain/entities/member_post.dart';
import '../../data/entity/comment.dart';

String? avatarUrlFor(Comment c) {
  try {
    if (c.owner.role == UserRole.member) {
      final member = c.owner.owner as MemberPost;
      return member.photo;
    } else {
      final company = c.owner.owner;
      return company?.logo;
    }
  } catch (_) {
    return null;
  }
}