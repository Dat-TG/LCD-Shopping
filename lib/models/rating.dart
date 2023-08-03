import 'dart:convert';

class Rating {
  final String userId;
  final String userName;
  final double rating;
  final String content;
  final int time;
  final String avatar;
  Rating(
      {required this.userId,
      required this.rating,
      required this.content,
      required this.time,
      required this.userName,
      required this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'content': content,
      'userName': userName,
      'time': time,
      'avatar': avatar
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
        userId: map['userId'] ?? '',
        rating: map['rating']?.toDouble() ?? 0.0,
        content: map['content'] ?? '',
        userName: map['userName'] ?? '',
        time: map['time'] ?? 0,
        avatar: map['avatar'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
