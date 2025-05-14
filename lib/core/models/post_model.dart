import 'comment_model.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final User author;
  final int stars;
  final int comments;
  final List<Comment> commentsList;
  final bool isEdited;
  final bool bookmarked;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.stars,
    required this.comments,
    this.commentsList = const [],
    this.isEdited = false,
    this.bookmarked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> commentsList = [];
    if (json['commentsList'] != null) {
      commentsList =
          (json['commentsList'] as List)
              .map((comment) => Comment.fromJson(comment))
              .toList();
    }

    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      author: User.fromJson(json['author']),
      stars: json['stars'],
      comments: json['comments'],
      commentsList: commentsList,
      isEdited: json['isEdited'] ?? false,
      bookmarked: json['bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': author.toJson(),
      'stars': stars,
      'comments': comments,
      'commentsList': commentsList.map((comment) => comment.toJson()).toList(),
      'isEdited': isEdited,
      'bookmarked': bookmarked,
    };
  }

  // Create a new post with updated fields
  Post copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    User? author,
    int? stars,
    int? comments,
    List<Comment>? commentsList,
    bool? isEdited,
    bool? bookmarked,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      stars: stars ?? this.stars,
      comments: comments ?? this.comments,
      commentsList: commentsList ?? this.commentsList,
      isEdited: isEdited ?? this.isEdited,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }
}

class User {
  final String id;
  final String name;
  final String role;
  final String? profilePic;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'role': role, 'profilePic': profilePic};
  }
}
