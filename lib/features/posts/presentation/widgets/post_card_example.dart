// Example usage of PostCard widget
// This file demonstrates how to use the PostCard widget in your app

import 'package:flutter/material.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';

class PostCardExample extends StatelessWidget {
  const PostCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Example: Using PostCard in a ListView
    return Scaffold(
      appBar: AppBar(title: const Text('Posts Feed')),
      body: ListView.builder(
        itemCount: 10, // Replace with your actual post count
        itemBuilder: (context, index) {
          // Replace this with your actual post data
          // final post = posts[index];

          return PostCard(
            post: _dummyPost, // Replace with actual post
            onLike: () {
              // Handle like action
              print('Post liked');
            },
            onComment: () {
              // Navigate to comments screen
              print('Open comments');
            },
            onShare: () {
              // Handle share action
              print('Share post');
            },
            onProfileTap: () {
              // Navigate to profile screen
              print('Open profile');
            },
          );
        },
      ),
    );
  }

  // This is just a placeholder - remove in production
  Post get _dummyPost =>
      throw UnimplementedError('Replace with actual post data');
}

/* 
USAGE EXAMPLE:

1. Simple usage:
   PostCard(post: myPost)

2. With callbacks:
   PostCard(
     post: myPost,
     onLike: () => handleLike(myPost.id),
     onComment: () => navigateToComments(myPost.id),
     onShare: () => sharePost(myPost),
     onProfileTap: () => navigateToProfile(myPost.userId),
   )

3. In a feed:
   ListView.builder(
     itemCount: posts.length,
     itemBuilder: (context, index) => PostCard(
       post: posts[index],
       // ... callbacks
     ),
   )

4. In a SingleChildScrollView:
   SingleChildScrollView(
     child: Column(
       children: posts.map((post) => PostCard(post: post)).toList(),
     ),
   )

FEATURES:
- ✅ User profile header with avatar and name
- ✅ Sector badge and timestamp
- ✅ Expandable content (show more/less)
- ✅ Image carousel with indicators
- ✅ Tags display
- ✅ Stats (likes, comments, shares)
- ✅ Action buttons with animations
- ✅ Options menu (save, copy link, report)
- ✅ Dark mode support
- ✅ Verified badge for companies
- ✅ Smooth animations
- ✅ Multi-language support

CUSTOMIZATION:
The widget automatically adapts to:
- Dark/Light theme
- Different screen sizes
- RTL/LTR languages
- Member/Company posts
*/
