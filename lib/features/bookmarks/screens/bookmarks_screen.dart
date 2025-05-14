import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/comment_model.dart';
import '../../../widgets/common/post_card.dart';
import '../../../features/comments/screens/comments_screen.dart';
import 'package:share_plus/share_plus.dart';

class BookmarksScreen extends StatefulWidget {
  final List<Post> bookmarkedPosts;
  final Function(String, bool) onBookmarkToggled;
  final Function(String, String)? onCommentAdded;

  const BookmarksScreen({
    Key? key,
    required this.bookmarkedPosts,
    required this.onBookmarkToggled,
    this.onCommentAdded,
  }) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late List<Post> _bookmarkedPosts;

  @override
  void initState() {
    super.initState();
    _bookmarkedPosts = List.from(widget.bookmarkedPosts);
  }

  void _handleBookmarkToggle(String postId, bool isBookmarked) {
    // Call parent callback
    widget.onBookmarkToggled(postId, isBookmarked);

    // Update local state
    setState(() {
      if (!isBookmarked) {
        // Remove post from list if unbookmarked
        _bookmarkedPosts.removeWhere((post) => post.id == postId);
      } else {
        // This shouldn't happen in this screen but handle it anyway
        final index = _bookmarkedPosts.indexWhere((post) => post.id == postId);
        if (index >= 0) {
          _bookmarkedPosts[index] = _bookmarkedPosts[index].copyWith(
            bookmarked: true,
          );
        }
      }
    });
  }

  // Handle adding a comment to a post
  void _addComment(int postIndex, String commentText) {
    // Get the post
    final post = _bookmarkedPosts[postIndex];
    final now = DateTime.now();

    // Create a new comment
    final newComment = Comment(
      id: now.millisecondsSinceEpoch.toString(),
      text: commentText,
      author: post.author, // Using same user for demo purposes
      timestamp: now,
    );

    setState(() {
      // Create new commentsList with added comment
      final updatedCommentsList = List<Comment>.from(post.commentsList)
        ..add(newComment);

      // Update the post with new comment and increment comment count
      _bookmarkedPosts[postIndex] = post.copyWith(
        comments: post.comments + 1,
        commentsList: updatedCommentsList,
      );
    });

    // Notify parent if callback is provided
    if (widget.onCommentAdded != null) {
      widget.onCommentAdded!(post.id, commentText);
    }
  }

  // Share post content
  void _sharePost(Post post) {
    final String shareText = '''
${post.title}

${post.content}

Posted by ${post.author.name}, ${post.author.role}

via CataLift App
''';

    Share.share(shareText, subject: post.title)
        .then((ShareResult result) {
          // Only show success message if actually shared
          if (result.status == ShareResultStatus.success) {
            // Show a snackbar after sharing with modern styling
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Post shared successfully!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }
        })
        .catchError((error) {
          // Show error if sharing fails with modern styling
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Failed to share: $error',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_bookmarkedPosts.length} saved',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body:
          _bookmarkedPosts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                itemCount: _bookmarkedPosts.length,
                itemBuilder: (context, index) {
                  final post = _bookmarkedPosts[index];
                  return PostCard(
                    post: post,
                    onCommentTap: () {
                      // Navigate to comments screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CommentsScreen(
                                post: post,
                                onAddComment: (commentText) {
                                  _addComment(index, commentText);
                                },
                              ),
                        ),
                      );
                    },
                    onShareTap: () => _sharePost(post),
                    onBookmarkTap: (isBookmarked) {
                      _handleBookmarkToggle(post.id, isBookmarked);
                    },
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_border,
              size: 72,
              color: Colors.blue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No bookmarks yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              'Save posts to read later by tapping the bookmark icon',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(LucideIcons.arrowLeft, size: 16),
            label: const Text('Go back to feed'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
