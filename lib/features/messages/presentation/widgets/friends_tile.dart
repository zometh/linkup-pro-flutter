import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class FriendsTile extends StatelessWidget {
  final String id;
  final String displayName;
  final String? photoUrl;
  final VoidCallback? onTap;
  const FriendsTile({
    super.key,
    required this.id,
    required this.displayName,
    this.photoUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
        child: photoUrl == null ? const Icon(Icons.person) : null,
      ),
      title: CustomText(text: displayName),
      // subtitle: Text(id),
      onTap: onTap,
    );
  }
}
