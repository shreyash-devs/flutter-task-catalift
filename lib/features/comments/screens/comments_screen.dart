import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/comment_model.dart';

class CommentsScreen extends StatefulWidget {
  final Post post;
  final Function(String) onAddComment;

  const CommentsScreen({
    Key? key,
    required this.post,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  // Local state for comments
  late List<Comment> _comments;

  // Track which comment is being replied to
  Comment? _replyingTo;

  // Set of liked comment IDs
  final Set<String> _likedComments = {};

  @override
  void initState() {
    super.initState();
    // Initialize local comments list from the post
    _comments = List.from(widget.post.commentsList);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  // Handle adding a comment locally
  void _handleAddComment() {
    final commentText = _commentController.text.trim();

    if (commentText.isNotEmpty) {
      final now = DateTime.now();
      // Create a new comment
      final newComment = Comment(
        id: now.millisecondsSinceEpoch.toString(),
        text: commentText,
        author: widget.post.author, // Using post author for demo
        timestamp: now,
        likes: 0,
        // Add reply reference if replying to a comment
        replyTo: _replyingTo?.id,
      );

      // Add to local comments list
      setState(() {
        _comments.add(newComment);
        // Clear replying state
        _replyingTo = null;
      });

      // Pass to parent callback
      widget.onAddComment(commentText);

      // Clear the input
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  // Handle liking a comment
  void _handleLikeComment(Comment comment) {
    setState(() {
      if (_likedComments.contains(comment.id)) {
        // Unlike
        _likedComments.remove(comment.id);
        // Find and update comment
        final index = _comments.indexWhere((c) => c.id == comment.id);
        if (index >= 0) {
          _comments[index] = _comments[index].copyWith(
            likes: _comments[index].likes - 1,
          );
        }
      } else {
        // Like
        _likedComments.add(comment.id);
        // Find and update comment
        final index = _comments.indexWhere((c) => c.id == comment.id);
        if (index >= 0) {
          _comments[index] = _comments[index].copyWith(
            likes: _comments[index].likes + 1,
          );
        }
      }
    });
  }

  // Set up to reply to a comment
  void _setupReply(Comment comment) {
    setState(() {
      _replyingTo = comment;
    });

    // Focus the text field
    _commentFocusNode.requestFocus();

    // Scroll to the comment input
    Future.delayed(const Duration(milliseconds: 300), () {
      Scrollable.ensureVisible(
        _commentFocusNode.context!,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  // Cancel replying
  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Comments',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Post summary
          _buildPostSummary(),

          // Comments list
          Expanded(
            child:
                _comments.isEmpty ? _buildEmptyState() : _buildCommentsList(),
          ),

          // Comment input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with subtle shadow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  widget.post.author.profilePic != null
                      ? CachedNetworkImageProvider(
                        widget.post.author.profilePic!,
                      )
                      : null,
              child:
                  widget.post.author.profilePic == null
                      ? const Icon(
                        LucideIcons.user,
                        color: Colors.grey,
                        size: 18,
                      )
                      : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.author.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    Text(
                      'Original Post',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  widget.post.title.isNotEmpty
                      ? widget.post.title
                      : widget.post.content.substring(
                            0,
                            widget.post.content.length > 100
                                ? 100
                                : widget.post.content.length,
                          ) +
                          (widget.post.content.length > 100 ? '...' : ''),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.messageCircle,
              size: 56,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No comments yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Be the first to comment on this post',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 30),
          // Add a button to focus the comment input
          ElevatedButton.icon(
            onPressed: () {
              _commentFocusNode.requestFocus();
            },
            icon: const Icon(LucideIcons.messageSquarePlus, size: 18),
            label: const Text('Add a comment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
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

  Widget _buildCommentsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _buildCommentItem(comment);
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    // Check if this comment has replies
    final hasReplies = _comments.any((c) => c.replyTo == comment.id);
    // Check if comment is liked
    final isLiked = _likedComments.contains(comment.id);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        // Add indentation for replies
        comment.replyTo != null ? 40 : 16,
        10,
        16,
        10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar with subtle shadow
          Container(
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: comment.replyTo != null ? 14 : 18, // Smaller for replies
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  comment.author.profilePic != null
                      ? CachedNetworkImageProvider(comment.author.profilePic!)
                      : null,
              child:
                  comment.author.profilePic == null
                      ? Icon(
                        LucideIcons.user,
                        color: Colors.grey,
                        size: comment.replyTo != null ? 12 : 16,
                      )
                      : null,
            ),
          ),

          const SizedBox(width: 14),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment bubble with light background
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(18),
                    border:
                        isLiked
                            ? Border.all(color: Colors.blue.withOpacity(0.3))
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Author name and timestamp
                      Row(
                        children: [
                          Text(
                            comment.author.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatTimestamp(comment.timestamp),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),

                      // Show "replying to" if this is a reply
                      if (comment.replyTo != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 6),
                          child: Text(
                            'Replying to a comment',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                      const SizedBox(height: 6),

                      // Comment text
                      Text(
                        comment.text,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Like button and counter
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () => _handleLikeComment(comment),
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : LucideIcons.thumbsUp,
                                  size: 14,
                                  color:
                                      isLiked ? Colors.red : Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                if (comment.likes > 0)
                                  Text(
                                    comment.likes.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color:
                                          isLiked
                                              ? Colors.red
                                              : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          onTap: () => _setupReply(comment),
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              'Reply',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add space if this comment has replies
                if (hasReplies) const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Show reply indicator if replying
          if (_replyingTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.reply, size: 14, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Replying to ${_replyingTo!.author.name}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.blue[700],
                    onPressed: _cancelReply,
                  ),
                ],
              ),
            ),

          Row(
            children: [
              // Avatar with subtle shadow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      widget.post.author.profilePic != null
                          ? CachedNetworkImageProvider(
                            widget.post.author.profilePic!,
                          )
                          : null,
                  child:
                      widget.post.author.profilePic == null
                          ? const Icon(
                            LucideIcons.user,
                            color: Colors.grey,
                            size: 16,
                          )
                          : null,
                ),
              ),
              const SizedBox(width: 12),
              // Text field with improved design
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          _replyingTo != null
                              ? 'Reply to ${_replyingTo!.author.name}...'
                              : 'Add a comment...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Modern send button
              Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: _handleAddComment,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(
                      LucideIcons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
