import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

enum FollowListType { followers, following }

class FollowListSheet extends ConsumerStatefulWidget {
  final String userId;
  final FollowListType type;
  final String userName;
  final void Function(int followersCount, int followingCount)? onCountsUpdated;

  const FollowListSheet({
    super.key,
    required this.userId,
    required this.type,
    required this.userName,
    this.onCountsUpdated,
  });

  @override
  ConsumerState<FollowListSheet> createState() => _FollowListSheetState();
}

class _FollowListSheetState extends ConsumerState<FollowListSheet> {
  final _apiClient = GetIt.I<ApiClient>();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final endpoint = widget.type == FollowListType.followers
          ? '/follow/followers/${widget.userId}'
          : '/follow/following/${widget.userId}';

      final response = await _apiClient.getOne(endpoint);

      final key = widget.type == FollowListType.followers ? 'followers' : 'following';
      final users = response[key] as List?;

      setState(() {
        _users = users?.cast<Map<String, dynamic>>() ?? [];
        _isLoading = false;
      });

      // Après chargement de la liste, récupérer les stats pour synchroniser les compteurs
      try {
        final statsResp = await _apiClient.getOne('/follow/stats/${widget.userId}');
        final followersCount = statsResp['followersCount'] as int? ?? 0;
        final followingCount = statsResp['followingCount'] as int? ?? 0;
        if (widget.onCountsUpdated != null) {
          widget.onCountsUpdated!(followersCount, followingCount);
        }
      } catch (_) {
        // ignore - ne bloque pas l'affichage de la liste
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = widget.type == FollowListType.followers
        ? 'followers'.tr()
        : 'following'.tr();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                Expanded(
                  child: CustomText(
                    text: title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance for close button
              ],
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? Colors.white10 : Colors.grey[200],
          ),

          // Content
          Expanded(
            child: _buildContent(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'Erreur de chargement',
              fontSize: 16,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadUsers,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.type == FollowListType.followers
                  ? Icons.people_outline
                  : Icons.person_add_outlined,
              size: 48,
              color: isDark ? Colors.white24 : AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: widget.type == FollowListType.followers
                  ? 'Aucun abonné'
                  : 'Aucun abonnement',
              fontSize: 16,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserTile(isDark, user);
      },
    );
  }

  Widget _buildUserTile(bool isDark, Map<String, dynamic> user) {
    final displayName = user['displayName'] ??
        '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
    final username = user['username'] ?? '';
    final imageUrl = user['imageUrl'] ??
        user['profile']?['photo'] ??
        user['companies']?['logo'];
    final userId = user['id'];

    return ListTile(
      onTap: () {
        GoRouter.of(context).pop();
        context.push('/user/$userId');
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
        child: imageUrl == null
            ? Icon(
                user['companies'] != null ? Icons.business : Icons.person,
                color: isDark ? Colors.white54 : AppColors.textTertiary,
              )
            : null,
      ),
      title: CustomText(
        text: displayName.isNotEmpty ? displayName : username,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
      subtitle: username.isNotEmpty
          ? CustomText(
              text: '@$username',
              fontSize: 13,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.white38 : AppColors.textTertiary,
      ),
    );
  }
}

/// Fonction utilitaire pour ouvrir la liste des followers/following
void showFollowList(
  BuildContext context, {
  required String userId,
  required FollowListType type,
  required String userName,
  void Function(int followersCount, int followingCount)? onCountsUpdated,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FollowListSheet(
      userId: userId,
      type: type,
      userName: userName,
      onCountsUpdated: onCountsUpdated,
    ),
  );
}
