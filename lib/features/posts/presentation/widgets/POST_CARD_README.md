# PostCard Widget Documentation

## Overview
The `PostCard` is a modern, beautiful, and fully-featured widget designed to display social media posts in the LinkUp Pro app. It supports both member and company posts with rich media, interactions, and animations.

## Features

### 🎨 Visual Design
- **Modern UI**: Clean, card-based design with subtle shadows and rounded corners
- **Dark Mode**: Full support for dark/light themes with adaptive colors
- **Smooth Animations**: Fade-in, slide, and scale animations for enhanced UX
- **Responsive**: Adapts to different screen sizes and orientations

### 👤 User Profile Section
- **Avatar Display**: Shows user/company profile picture with fallback to initials
- **Verified Badge**: Blue checkmark for verified company accounts
- **Sector Badge**: Displays the user's professional sector in a pill
- **Relative Timestamps**: "2 hours ago", "3 days ago" using timeago package
- **Profile Navigation**: Tap avatar to navigate to user profile

### 📝 Content Features
- **Smart Text Expansion**: Auto-collapse long content (>200 chars) with "Show more/less"
- **Smooth Transitions**: CrossFade animation between expanded/collapsed states
- **Rich Text Display**: Proper line height and formatting

### 🖼️ Media Gallery
- **Single Image**: Full-width display with rounded corners
- **Image Carousel**: Swipe through multiple images
- **Page Indicators**: Animated dots showing current image position
- **Loading States**: Shimmer loading while images load
- **Error Handling**: Graceful fallback for broken images
- **Video Support**: Video placeholder with play icon

### 🏷️ Tags Section
- **Hashtags Display**: Beautiful gradient-styled tag chips
- **Smart Layout**: Wrap layout for multiple tags
- **Clickable**: Ready for tag navigation/filtering

### 📊 Engagement Stats
- **Counters**: Like, comment, and share counts
- **Smart Formatting**: 1.2K, 2.5M for large numbers
- **Color-coded Icons**: Different colors for each stat type

### 🎯 Action Buttons
- **Like Button**: Toggle with heart animation and color change
- **Comment Button**: Opens comment section
- **Share Button**: Triggers share functionality
- **Ripple Effect**: Material ink splash on tap
- **Animated**: Scale animation on interaction

### ⚙️ Options Menu
- **Bottom Sheet**: Modern bottom sheet with rounded corners
- **Save Post**: Bookmark functionality
- **Copy Link**: Share post URL
- **Report**: Flag inappropriate content
- **Slide Animation**: Smooth slide-up animation

## Usage

### Basic Usage
```dart
PostCard(
  post: myPost,
)
```

### With All Callbacks
```dart
PostCard(
  post: myPost,
  onLike: () {
    // Handle like logic
    postService.likePost(myPost.id);
  },
  onComment: () {
    // Navigate to comments
    context.push('/posts/${myPost.id}/comments');
  },
  onShare: () {
    // Share post
    Share.share('Check out this post on LinkUp Pro!');
  },
  onProfileTap: () {
    // Navigate to profile
    context.push('/profile/${myPost.userId}');
  },
)
```

### In a Feed List
```dart
ListView.builder(
  itemCount: posts.length,
  padding: EdgeInsets.symmetric(vertical: 8),
  itemBuilder: (context, index) {
    final post = posts[index];
    return PostCard(
      key: ValueKey(post.id),
      post: post,
      onLike: () => _handleLike(post.id),
      onComment: () => _handleComment(post.id),
      onShare: () => _handleShare(post),
      onProfileTap: () => _handleProfileTap(post.userId),
    );
  },
)
```

### With RefreshIndicator
```dart
RefreshIndicator(
  onRefresh: () async {
    await fetchPosts();
  },
  child: ListView.builder(
    itemCount: posts.length,
    itemBuilder: (context, index) => PostCard(post: posts[index]),
  ),
)
```

## Props

| Property | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `post` | `Post` | ✅ Yes | - | The post entity to display |
| `onLike` | `VoidCallback?` | ❌ No | `null` | Callback when like button is pressed |
| `onComment` | `VoidCallback?` | ❌ No | `null` | Callback when comment button is pressed |
| `onShare` | `VoidCallback?` | ❌ No | `null` | Callback when share button is pressed |
| `onProfileTap` | `VoidCallback?` | ❌ No | `null` | Callback when avatar/profile is tapped |

## Post Entity Structure

The widget expects a `Post` object with the following structure:

```dart
class Post {
  final String id;
  final String content;
  final DateTime publicationDate;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<PostFile> files;
  final String userId;
  final List<String> tags;
  final PostOwner owner;
}
```

### PostOwner Structure
```dart
class PostOwner {
  final UserRole role; // UserRole.member or UserRole.entreprise
  final String id;
  final String sector;
  final dynamic owner; // MemberPost or CompanyPost
}
```

### MemberPost Structure
```dart
class MemberPost {
  final String firstName;
  final String lastName;
  final String? photo;
}
```

### CompanyPost Structure
```dart
class CompanyPost {
  final String name;
  final String logo;
}
```

### PostFile Structure
```dart
class PostFile {
  final String fileId;
  final String url;
  final String fileType; // "image/jpeg", "video/mp4", etc.
}
```

## Styling & Theming

The widget uses the app's theme and color scheme:
- Primary color for accents and highlights
- Adaptive text colors for dark/light modes
- Material Design elevation and shadows
- Custom gradients from `AppGradients`
- Colors from `AppColors` constants

## Localization

The widget supports multiple languages through `easy_localization`:
- English (en)
- French (fr)
- Arabic (ar)

Required translation keys:
- `show_more`
- `show_less`
- `like`
- `comment`
- `share`
- `save_post`
- `copy_link`
- `report`

## Dependencies

```yaml
dependencies:
  flutter_animate: ^4.5.2
  cached_network_image: ^3.4.1
  easy_localization: ^3.0.8
  timeago: ^3.7.0
```

## Animations

The widget includes several animations:
- **Card entrance**: 400ms fade-in + slide-up
- **Content expansion**: 300ms cross-fade
- **Like button**: 200ms scale animation
- **Page indicators**: 300ms scale-X animation
- **Bottom sheet**: 300ms slide-up animation

## Performance Optimization

- Uses `CachedNetworkImage` for efficient image loading and caching
- Implements proper disposal of `PageController`
- Efficient state management with minimal rebuilds
- Lazy loading for images in carousel

## Accessibility

- Semantic labels for screen readers
- Sufficient touch target sizes (48x48 minimum)
- Color contrast meets WCAG standards
- Clear visual feedback for interactions

## Best Practices

1. **Always provide a key** when using in lists:
   ```dart
   PostCard(key: ValueKey(post.id), post: post)
   ```

2. **Handle callbacks gracefully**:
   ```dart
   onLike: () async {
     try {
       await likePost(post.id);
     } catch (e) {
       showErrorSnackbar(e.toString());
     }
   }
   ```

3. **Use pagination** for large feeds:
   ```dart
   ListView.builder(
     itemCount: posts.length + 1,
     itemBuilder: (context, index) {
       if (index == posts.length) {
         return LoadMoreIndicator(onLoadMore: fetchMorePosts);
       }
       return PostCard(post: posts[index]);
     },
   )
   ```

4. **Implement pull-to-refresh**:
   ```dart
   RefreshIndicator(
     onRefresh: refreshFeed,
     child: ListView(...),
   )
   ```

## Customization Examples

### Different Card Spacing
```dart
PostCard(post: post)
  .padding(EdgeInsets.all(16))
```

### Custom Animations
```dart
PostCard(post: post)
  .animate()
  .fadeIn(delay: Duration(milliseconds: index * 100))
```

## Troubleshooting

### Images not loading?
- Check network permissions in AndroidManifest.xml and Info.plist
- Verify image URLs are valid and accessible
- Check CachedNetworkImage configuration

### Translations not working?
- Ensure `EasyLocalization` is initialized in main.dart
- Verify translation JSON files are in `assets/translations/`
- Check `pubspec.yaml` includes translation assets

### Dark mode issues?
- Verify theme is properly configured in MaterialApp
- Check `Theme.of(context).brightness` returns correct value
- Ensure colors have proper contrast in both modes

## Future Enhancements

Potential features to add:
- [ ] Video playback with controls
- [ ] GIF support
- [ ] Long-press to preview images
- [ ] Swipe actions (archive, delete)
- [ ] Pinch to zoom images
- [ ] Multiple image layout (grid for 4+ images)
- [ ] Reaction animations (floating hearts)
- [ ] Read more with fade gradient
- [ ] Poll support
- [ ] Link preview cards

## Contributing

When modifying the PostCard:
1. Maintain backward compatibility
2. Update this documentation
3. Add tests for new features
4. Follow the existing code style
5. Update translation files

## License

Part of the LinkUp Pro project. See main LICENSE file.

---

**Created with ❤️ for LinkUp Pro**
