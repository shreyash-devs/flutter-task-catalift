import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/colors.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/comment_model.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/search_bar_widget.dart';
import '../../../widgets/common/post_card.dart';
import '../../comments/screens/comments_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bookmarks/screens/bookmarks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Original post list
  final List<Post> _allPosts = [
    Post(
      id: '1',
      title: 'The Briggs-Rauscher Reaction: A Mesmerizing Chemical Dance 🌈',
      content:
          'This captivating process uses hydrogen peroxide, potassium iodate, malonic acid, manganese sulfate, and starch.\nIodine and iodate ions interact to form compounds that the solution\'s color ♥',
      imageUrl: 'https://images.unsplash.com/photo-1617791160505-6f00504e3519',
      author: User(
        id: '101',
        name: 'Akhilesh Yadav',
        role: 'Founder at Google',
        profilePic: 'https://randomuser.me/api/portraits/men/1.jpg',
      ),
      stars: 1546,
      comments: 80,
      commentsList: [], // Initialize with empty list
      isEdited: true,
    ),
    Post(
      id: '2',
      title: 'Quantum Computing Breakthrough: 1000 Qubit Processor Achieved 🧪',
      content:
          'Scientists at MIT have created the world\'s first 1000-qubit quantum processor, shattering previous records. The new architecture uses a novel approach to qubit stabilization that drastically reduces decoherence.\n\nThis breakthrough could accelerate quantum applications in cryptography, material science, and complex system modeling decades ahead of previous predictions.',
      imageUrl: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
      author: User(
        id: '102',
        name: 'Priya Sharma',
        role: 'Quantum Physicist at IBM',
        profilePic: 'https://randomuser.me/api/portraits/women/2.jpg',
      ),
      stars: 2341,
      comments: 156,
      commentsList: [],
      isEdited: false,
    ),
    Post(
      id: '3',
      title: 'AI System Generates Novel Medicines From Scratch 🤖💊',
      content:
          'DeepMind\'s latest AI system, MoleculeFormer, can now design entirely new pharmaceutical compounds with specific therapeutic properties without human input.\n\nIn tests, the system created novel antibiotics effective against multi-resistant bacteria by exploring chemical structures humans have never considered. Clinical trials are expected to begin next year.',
      imageUrl: 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69',
      author: User(
        id: '103',
        name: 'Rajiv Kumar',
        role: 'AI Research Lead at DeepMind',
        profilePic: 'https://randomuser.me/api/portraits/men/3.jpg',
      ),
      stars: 3219,
      comments: 243,
      commentsList: [],
      isEdited: true,
    ),
    Post(
      id: '4',
      title: 'New Solar Panel Design Achieves 47% Efficiency 🔆',
      content:
          'Engineers at Stanford have developed a multi-junction solar cell using a novel semiconductor layering technique that achieves 47% sunlight-to-electricity conversion efficiency, smashing the theoretical limit previously thought possible.\n\nThe breakthrough could reduce solar installation costs by more than half, making renewable energy cheaper than fossil fuels in nearly every market worldwide.',
      imageUrl: 'https://images.unsplash.com/photo-1509391366360-2e959784a276',
      author: User(
        id: '104',
        name: 'Ananya Patel',
        role: 'Renewable Energy Researcher',
        profilePic: 'https://randomuser.me/api/portraits/women/4.jpg',
      ),
      stars: 1876,
      comments: 129,
      commentsList: [],
      isEdited: false,
    ),
    Post(
      id: '5',
      title: 'Brain-Computer Interface Allows Typing at 100 WPM 🧠⌨️',
      content:
          'Neuralink\'s latest implantable BCI has achieved a major milestone, allowing users to type at speeds exceeding 100 words per minute using only thought. The miniaturized device uses 12,000 microscopic electrodes to interpret neural signals with unprecedented precision.\n\nEarly testers report that using the interface becomes second nature within hours, feeling like "an extension of their thoughts rather than a controlled device."',
      imageUrl: 'https://images.unsplash.com/photo-1589254065878-42c9da997008',
      author: User(
        id: '105',
        name: 'Vikram Singh',
        role: 'Neural Engineering Director',
        profilePic: 'https://randomuser.me/api/portraits/men/5.jpg',
      ),
      stars: 4215,
      comments: 387,
      commentsList: [],
      isEdited: false,
    ),
  ];

  // Filtered posts for display
  late List<Post> _filteredPosts;

  @override
  void initState() {
    super.initState();
    // Initially show all posts
    _filteredPosts = List.from(_allPosts);

    // Listen for changes in the search field
    _searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPosts);
    _searchController.dispose();
    super.dispose();
  }

  // Filter posts based on search query
  void _filterPosts() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        // If search is empty, show all posts
        _filteredPosts = List.from(_allPosts);
      } else {
        // Enhanced search algorithm with better matching and scoring
        final Map<Post, int> postScores = {};

        // Debug the search query
        debugPrint('SEARCH QUERY: "$query"');

        for (final post in _allPosts) {
          int score = 0;

          // Check various fields with different weights/priorities
          final titleMatches = _countMatches(post.title.toLowerCase(), query);
          final contentMatches = _countMatches(
            post.content.toLowerCase(),
            query,
          );

          // Author name matches
          final authorName = post.author.name.toLowerCase();
          final authorRole = post.author.role.toLowerCase();

          // Debug each post evaluation
          debugPrint(
            'Evaluating post: ${post.id} - ${post.title} by ${post.author.name}',
          );
          debugPrint('  Author name: "$authorName"');

          final authorNameMatches = _countMatches(authorName, query);
          final authorRoleMatches = _countMatches(authorRole, query);

          // Log exact name matching attempts
          final containsQueryInName = authorName.contains(query);
          debugPrint('  Contains "$query" in name: $containsQueryInName');

          // Split query into words for multi-word searching
          final queryWords =
              query.split(' ').where((word) => word.isNotEmpty).toList();

          // Use a more precise approach for partial matching
          bool hasNamePartialMatch = false;
          final nameParts = authorName.split(' ');
          debugPrint('  Name parts: $nameParts');

          for (final namePart in nameParts) {
            if (namePart.contains(query) || query.contains(namePart)) {
              hasNamePartialMatch = true;
              debugPrint('  ✓ Name part match: "$namePart" with "$query"');
              break;
            }
          }

          // Only give scores for legitimate matches
          if (titleMatches > 0) {
            score += titleMatches * 10;
            debugPrint(
              '  + Title matches: $titleMatches (score: ${titleMatches * 10})',
            );
          }

          if (contentMatches > 0) {
            score += contentMatches * 5;
            debugPrint(
              '  + Content matches: $contentMatches (score: ${contentMatches * 5})',
            );
          }

          if (authorNameMatches > 0) {
            score += authorNameMatches * 8;
            debugPrint(
              '  + Author name exact matches: $authorNameMatches (score: ${authorNameMatches * 8})',
            );
          }

          if (authorRoleMatches > 0) {
            score += authorRoleMatches * 6;
            debugPrint(
              '  + Role matches: $authorRoleMatches (score: ${authorRoleMatches * 6})',
            );
          }

          // Check for partial word matches - with stricter requirements
          // For partial matching, ensure the query is at least 3 chars and is a significant part of the word
          for (final word in queryWords) {
            if (word.length < 3) continue; // Skip very short terms

            bool foundPartialMatch = false;

            // For exact name matching, be more precise (fix the bug with false matches)
            for (final namePart in authorName.split(' ')) {
              // Check if the query is a true substring of the name part (not just any character overlap)
              if (namePart.contains(word)) {
                score += 4;
                foundPartialMatch = true;
                debugPrint(
                  '  + Partial name match: "$word" in "$namePart" (score: +4)',
                );
                break;
              }
            }

            // Only check other fields if we didn't already match the name
            if (!foundPartialMatch) {
              if (post.title.toLowerCase().contains(word)) {
                score += 3;
                debugPrint('  + Partial title match: "$word" (score: +3)');
              }

              if (post.content.toLowerCase().contains(word)) {
                score += 2;
                debugPrint('  + Partial content match: "$word" (score: +2)');
              }

              if (authorRole.contains(word)) {
                score += 3;
                debugPrint('  + Partial role match: "$word" (score: +3)');
              }
            }
          }

          // Handle exact matches with high priority
          if (post.title.toLowerCase() == query) {
            score += 50;
            debugPrint('  + Exact title match! (score: +50)');
          }

          if (authorName == query) {
            score += 40;
            debugPrint('  + Exact author name match! (score: +40)');
          }

          // If the query is a significant part of the full name (first or last name)
          for (final namePart in authorName.split(' ')) {
            if (namePart == query ||
                namePart.startsWith(query) && query.length >= 3) {
              score += 30;
              debugPrint(
                '  + Strong name part match! "$namePart" (score: +30)',
              );
              break;
            }
          }

          // Check comment content as well
          int commentMatches = 0;
          for (final comment in post.commentsList) {
            final matchesInComment = _countMatches(
              comment.text.toLowerCase(),
              query,
            );
            if (matchesInComment > 0) {
              commentMatches += matchesInComment;
              score +=
                  4 * matchesInComment; // Add points for each matching comment
            }
          }

          if (commentMatches > 0) {
            debugPrint(
              '  + Comment matches: $commentMatches (score: ${commentMatches * 4})',
            );
          }

          // If there's any match, add to results with score
          if (score > 0) {
            postScores[post] = score;
            debugPrint('  TOTAL SCORE: $score');
          } else {
            debugPrint('  NO MATCHES FOUND (score: 0)');
          }

          debugPrint('--------------------');
        }

        // Convert to list and sort by score (highest first)
        _filteredPosts =
            postScores.keys.toList()
              ..sort((a, b) => postScores[b]! - postScores[a]!);

        // Log search results summary
        debugPrint(
          'SEARCH RESULTS for "$query": found ${_filteredPosts.length} posts',
        );
        if (_filteredPosts.isNotEmpty) {
          for (int i = 0; i < _filteredPosts.length; i++) {
            final post = _filteredPosts[i];
            debugPrint(
              '  #${i + 1}: ${post.author.name} - ${post.title.substring(0, post.title.length > 30 ? 30 : post.title.length)}... (Score: ${postScores[post]})',
            );
          }
        }
      }
    });
  }

  // Count occurrences of query in text (case insensitive)
  int _countMatches(String text, String query) {
    if (query.isEmpty || text.isEmpty) return 0;

    int count = 0;
    int index = 0;

    while (true) {
      index = text.indexOf(query, index);
      if (index == -1) break;

      count++;
      index += query.length;
    }

    return count;
  }

  void _addComment(int postIndex, String commentText) {
    // Find the post in the original list
    final originalIndex = _allPosts.indexWhere(
      (p) => p.id == _filteredPosts[postIndex].id,
    );
    if (originalIndex == -1) return;

    final post = _allPosts[originalIndex];
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: commentText,
      author: post.author, // Using same user for demo purposes
      timestamp: DateTime.now(),
    );

    setState(() {
      // Create new commentsList with added comment
      final updatedCommentsList = List<Comment>.from(post.commentsList)
        ..add(newComment);

      // Update the post with new comment
      _allPosts[originalIndex] = post.copyWith(
        comments: post.comments + 1,
        commentsList: updatedCommentsList,
      );

      // Also update in filtered list if present
      final filteredIndex = _filteredPosts.indexWhere((p) => p.id == post.id);
      if (filteredIndex != -1) {
        _filteredPosts[filteredIndex] = _allPosts[originalIndex];
      }
    });
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

  // Toggle bookmark status for a post
  void _toggleBookmark(String postId, bool isBookmarked) {
    setState(() {
      // Find the post in the original list first
      final originalIndex = _allPosts.indexWhere((p) => p.id == postId);
      if (originalIndex >= 0) {
        _allPosts[originalIndex] = _allPosts[originalIndex].copyWith(
          bookmarked: isBookmarked,
        );
      }

      // Update in filtered list if present
      final filteredIndex = _filteredPosts.indexWhere((p) => p.id == postId);
      if (filteredIndex >= 0) {
        _filteredPosts[filteredIndex] = _filteredPosts[filteredIndex].copyWith(
          bookmarked: isBookmarked,
        );
      }
    });
  }

  // Navigate to bookmarks screen
  void _navigateToBookmarks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BookmarksScreen(
              bookmarkedPosts:
                  _allPosts.where((post) => post.bookmarked).toList(),
              onBookmarkToggled: _toggleBookmark,
              onCommentAdded: _handleCommentFromBookmarks,
            ),
      ),
    );
  }

  // Handle comment added from bookmarks screen
  void _handleCommentFromBookmarks(String postId, String commentText) {
    final now = DateTime.now();
    // Create a new comment
    final newComment = Comment(
      id: now.millisecondsSinceEpoch.toString(),
      text: commentText,
      author: _allPosts.first.author, // Using first post's author for demo
      timestamp: now,
    );

    setState(() {
      // Find the post in the original list
      final originalIndex = _allPosts.indexWhere((p) => p.id == postId);
      if (originalIndex >= 0) {
        // Create new commentsList with added comment
        final updatedCommentsList = List<Comment>.from(
          _allPosts[originalIndex].commentsList,
        )..add(newComment);

        // Update the post with new comment and increment comment count
        _allPosts[originalIndex] = _allPosts[originalIndex].copyWith(
          comments: _allPosts[originalIndex].comments + 1,
          commentsList: updatedCommentsList,
        );
      }

      // Update in filtered list if present
      final filteredIndex = _filteredPosts.indexWhere((p) => p.id == postId);
      if (filteredIndex >= 0) {
        // Create new commentsList with added comment
        final updatedCommentsList = List<Comment>.from(
          _filteredPosts[filteredIndex].commentsList,
        )..add(newComment);

        // Update the post with new comment and increment comment count
        _filteredPosts[filteredIndex] = _filteredPosts[filteredIndex].copyWith(
          comments: _filteredPosts[filteredIndex].comments + 1,
          commentsList: updatedCommentsList,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        actions: [
          // Bookmark button in app bar
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.bookmark,
                    color: Colors.blue,
                    size: 24,
                  ),
                  onPressed: _navigateToBookmarks,
                ),
                // Badge showing bookmarked count
                if (_allPosts.where((p) => p.bookmarked).isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _allPosts.where((p) => p.bookmarked).length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: (value) {
              // The listener will handle filtering
            },
            onAddTap: () {
              // Handle add tap
            },
          ),

          // Search results status
          if (_searchController.text.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _filteredPosts.isEmpty
                        ? Icons.search_off
                        : Icons.filter_list,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _filteredPosts.isEmpty
                        ? 'No results found'
                        : '${_filteredPosts.length} ${_filteredPosts.length == 1 ? 'result' : 'results'} found',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterPosts();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child:
                _filteredPosts.isEmpty && _searchController.text.isNotEmpty
                    ? _buildEmptySearchResult()
                    : ListView.builder(
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
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
                          onShareTap: () {
                            // Share the post
                            _sharePost(post);
                          },
                          onBookmarkTap: (isBookmarked) {
                            _toggleBookmark(post.id, isBookmarked);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchResult() {
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
            child: Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check spelling',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              _filterPosts();
            },
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Show all posts'),
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
