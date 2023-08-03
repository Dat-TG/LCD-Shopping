import 'dart:convert';

class Rating {
  final String userId;
  final double rating;
  final String content;
  Rating({
    required this.userId,
    required this.rating,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'rating': rating, 'content': content};
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
