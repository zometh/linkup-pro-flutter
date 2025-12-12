import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/posts/domain/entities/user_preview_adds.dart';

class FullConversationAppbar extends ConsumerStatefulWidget {
  const FullConversationAppbar({super.key});

  @override
  ConsumerState<FullConversationAppbar> createState() =>
      _FullConversationAppbarState();
}

class _FullConversationAppbarState
    extends ConsumerState<FullConversationAppbar> {
  UserPreviewAdds? userPreviewAdds;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  fetchUsersInfos() async {
    // final postImplement = GetIt.I<PostRepositoryImpl>();
    //final response = await postImplement.getUserPreview(widget.post.userId);
  }
}
