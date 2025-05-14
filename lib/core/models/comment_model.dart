import 'package:cataliftapp/core/models/post_model.dart';

class Comment {
  final String id;
  final String text;
  final User author;
  final DateTime timestamp;
  final int likes;
  final String? replyTo; // Reference to parent comment ID if this is a reply

  Comment({
    required this.id,
    required this.text,
    required this.author,
    required this.timestamp,
    this.likes = 0,
    this.replyTo,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      author: User.fromJson(json['author']),
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'] ?? 0,
      replyTo: json['replyTo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author.toJson(),
      'timestamp': timestamp.toISOString(),
      'likes': likes,
      'replyTo': replyTo,
    };
  }

  // Create a copy of this Comment with updated fields
  Comment copyWith({
    String? id,
    String? text,
    User? author,
    DateTime? timestamp,
    int? likes,
    String? replyTo,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}

// Extension to format DateTime for JSON
extension DateTimeExtension on DateTime {
  String toISOString() {
    return toUtc().toIso8601String();
  }
}
