import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/colors.dart';
import '../../core/models/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShareTap;
  final Function(bool)? onBookmarkTap;

  const PostCard({
    Key? key,
    required this.post,
    this.onCommentTap,
    this.onShareTap,
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late Post _post;
  late bool _isStarred;
  bool _isFollowing = false;
  bool _isBookmarked = false;
  bool _isExpanded = false;
  late AnimationController _starAnimationController;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isStarred = false;
    _isBookmarked = _post.bookmarked;

    // Setup animation for color changes only, no scaling
    _starAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _starAnimationController.dispose();
    super.dispose();
  }

  void _handleStarTap() {
    // Only animate color change, not scaling
    _starAnimationController.forward(from: 0.0);

    setState(() {
      _isStarred = !_isStarred;

      if (_isStarred) {
        // Increment stars count
        _post = _post.copyWith(stars: _post.stars + 1);
      } else {
        // Decrement stars count
        _post = _post.copyWith(stars: _post.stars - 1);
      }
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleFollowTap() {
    // Only animate color change
    _starAnimationController.forward(from: 0.0);

    setState(() {
      _isFollowing = !_isFollowing;
    });

    // Show success or unfollow message
    ScaffoldMessenger.of(context).clearSnackBars();
    if (_isFollowing) {
      // Show follow success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_post.author.name} has been added to your network!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    } else {
      // Show unfollow message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${_post.author.name} has been removed from your network',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  void _handleBookmarkTap() {
    // Only animate color change, not scaling
    _starAnimationController.forward(from: 0.0);

    setState(() {
      _isBookmarked = !_isBookmarked;
      _post = _post.copyWith(bookmarked: _isBookmarked);
    });

    if (widget.onBookmarkTap != null) {
      widget.onBookmarkTap!(_isBookmarked);
    }

    // Show bookmark feedback
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              _isBookmarked
                  ? 'Post added to bookmarks'
                  : 'Post removed from bookmarks',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor:
            _isBookmarked ? Colors.blue.shade600 : Colors.grey.shade600,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.95)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.03),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header with Author Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to author profile
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.15),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: _post.author.profilePic ?? '',
                              placeholder:
                                  (context, url) =>
                                      Container(color: Colors.grey[200]),
                              errorWidget:
                                  (context, url, error) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).animate().scale(
                          duration: 200.ms,
                          curve: Curves.easeOutCubic,
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _post.author.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _handleFollowTap,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _isFollowing
                                              ? AppColors.primaryColor
                                                  .withOpacity(0.1)
                                              : AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isFollowing
                                              ? LucideIcons.check
                                              : LucideIcons.plus,
                                          size: 14,
                                          color:
                                              _isFollowing
                                                  ? AppColors.primaryColor
                                                  : Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _isFollowing ? 'Following' : 'Follow',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                _isFollowing
                                                    ? AppColors.primaryColor
                                                    : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _post.author.role,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Post Content
                _post.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: _post.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            height: 200,
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.error_outline),
                            ),
                          ),
                    )
                    : const SizedBox.shrink(),

                // Post title and content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                            _post.title,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 100.ms)
                          .slideX(
                            begin: -0.1,
                            end: 0,
                            duration: 350.ms,
                            curve: Curves.easeOut,
                          ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _post.content,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textPrimary.withOpacity(0.9),
                            ),
                            maxLines: _isExpanded ? null : 5,
                            overflow:
                                _isExpanded ? null : TextOverflow.ellipsis,
                          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                          if (!_isExpanded && _post.content.length > 300)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: _toggleExpanded,
                                child: Row(
                                  children: [
                                    Text(
                                      'Show more',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      LucideIcons.chevronsDown,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (_isExpanded && _post.content.length > 300)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: _toggleExpanded,
                                child: Row(
                                  children: [
                                    Text(
                                      'Show less',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      LucideIcons.chevronsUp,
                                      size: 16,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom interaction strip with glassmorphism
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInteractionButton(
                                    _isStarred ? Icons.star : Icons.star_border,
                                    '${_post.stars}',
                                    _isStarred,
                                    _handleStarTap,
                                    AppColors.starColor,
                                  ),
                                  _buildInteractionButton(
                                    Icons.chat_bubble_outline,
                                    '${_post.comments}',
                                    false,
                                    widget.onCommentTap,
                                    AppColors.accentColor,
                                  ),
                                  _buildInteractionButton(
                                    Icons.share,
                                    'Share',
                                    false,
                                    widget.onShareTap,
                                    AppColors.primaryLight,
                                  ),
                                  _buildInteractionButton(
                                    _isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    'Save',
                                    _isBookmarked,
                                    _handleBookmarkTap,
                                    AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildInteractionButton(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback? onTap,
    Color activeColor,
  ) {
    final bool showLabel =
        (label == '${_post.stars}' || label == '${_post.comments}');

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding:
            showLabel
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
                : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isActive
                  ? activeColor.withOpacity(0.15)
                  : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isActive
                    ? activeColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: showLabel ? 16 : 18,
              color:
                  isActive
                      ? activeColor
                      : AppColors.textPrimary.withOpacity(0.8),
            ),
            if (showLabel) const SizedBox(width: 4),
            if (showLabel)
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isActive
                          ? activeColor
                          : AppColors.textPrimary.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
