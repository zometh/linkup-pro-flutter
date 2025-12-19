import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/features/search/domain/entities/search_entities.dart';

class SearchPersonCard extends StatelessWidget {
  final SearchResult result;
  final bool isDark;

  const SearchPersonCard({
    super.key,
    required this.result,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final data = result.data;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => context.push('/user/${result.id}'),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: data['photo'] != null
              ? CachedNetworkImageProvider(data['photo'])
              : null,
          child: data['photo'] == null
              ? Icon(Icons.person, color: isDark ? Colors.white54 : AppColors.textTertiary)
              : null,
        ),
        title: CustomText(
          text: data['name'] ?? 'Utilisateur',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['headline'] != null)
              CustomText(
                text: data['headline'],
                fontSize: 13,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
                maxLines: 1,
              ),
            if (data['sector'] != null)
              CustomText(
                text: data['sector'],
                fontSize: 12,
                color: AppColors.primary,
              ),
          ],
        ),
        trailing: _buildFollowIndicator(isDark, data['isFollowed'] ?? false),
      ),
    );
  }

  Widget _buildFollowIndicator(bool isDark, bool isFollowed) {
    if (isFollowed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: 'Suivi',
          fontSize: 11,
          color: AppColors.primary,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class SearchCompanyCard extends StatelessWidget {
  final SearchResult result;
  final bool isDark;

  const SearchCompanyCard({
    super.key,
    required this.result,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final data = result.data;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () => context.push('/user/${result.id}'),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: data['logo'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: data['logo'],
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.business,
                  color: isDark ? Colors.white54 : AppColors.textTertiary,
                ),
        ),
        title: CustomText(
          text: data['name'] ?? 'Entreprise',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['sector'] != null)
              CustomText(
                text: data['sector'],
                fontSize: 13,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
            if (data['activeJobsCount'] != null && data['activeJobsCount'] > 0)
              CustomText(
                text: '${data['activeJobsCount']} offre(s) d\'emploi',
                fontSize: 12,
                color: AppColors.primary,
              ),
          ],
        ),
        trailing: _buildFollowIndicator(isDark, data['isFollowed'] ?? false),
      ),
    );
  }

  Widget _buildFollowIndicator(bool isDark, bool isFollowed) {
    if (isFollowed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: 'Suivi',
          fontSize: 11,
          color: AppColors.primary,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class SearchPostCard extends StatelessWidget {
  final SearchResult result;
  final bool isDark;

  const SearchPostCard({
    super.key,
    required this.result,
    required this.isDark,
  });

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final dateTime = date is DateTime ? date : DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return 'Il y a ${difference.inMinutes} min';
        }
        return 'Il y a ${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays}j';
      } else if (difference.inDays < 30) {
        return 'Il y a ${(difference.inDays / 7).floor()} sem';
      } else {
        return DateFormat('dd MMM yyyy', 'fr').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = result.data;
    final author = data['author'] ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/post/${result.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: author['photo'] != null
                        ? CachedNetworkImageProvider(author['photo'])
                        : null,
                    child: author['photo'] == null
                        ? Icon(
                            author['isCompany'] == true ? Icons.business : Icons.person,
                            size: 20,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: author['name'] ?? 'Auteur',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        CustomText(
                          text: _formatDate(data['publicationDate']),
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomText(
                text: data['content'] ?? '',
                fontSize: 14,
                color: isDark ? Colors.white70 : AppColors.textPrimary,
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: '${data['likesCount'] ?? 0}',
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: '${data['commentsCount'] ?? 0}',
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchJobCard extends StatelessWidget {
  final SearchResult result;
  final bool isDark;

  const SearchJobCard({
    super.key,
    required this.result,
    required this.isDark,
  });

  String _formatDate(dynamic date) {
    if (date == null) return '';
    try {
      final dateTime = date is DateTime ? date : DateTime.parse(date.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return 'Il y a ${difference.inMinutes} min';
        }
        return 'Il y a ${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays}j';
      } else if (difference.inDays < 30) {
        return 'Il y a ${(difference.inDays / 7).floor()} sem';
      } else {
        return DateFormat('dd MMM yyyy', 'fr').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = result.data;
    final company = data['company'] ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/job/${result.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: company['logo'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: company['logo'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.business,
                        color: isDark ? Colors.white54 : AppColors.textTertiary,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: data['title'] ?? 'Offre',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: company['name'] ?? '',
                      fontSize: 13,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (data['employmentType'] != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: CustomText(
                              text: data['employmentType'],
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        CustomText(
                          text: _formatDate(data['postedDate']),
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textTertiary,
                        ),
                      ],
                    ),
                    if (data['hasApplied'] == true) ...[
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          CustomText(
                            text: 'Candidature envoyée',
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

