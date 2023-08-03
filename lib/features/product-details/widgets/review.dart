import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/common/widgets/stars.dart';
import 'package:shopping/models/rating.dart';

class Review extends StatelessWidget {
  final Rating rating;
  const Review({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: rating.avatar.isNotEmpty
                  ? NetworkImage(rating.avatar) as ImageProvider
                  : const AssetImage('assets/images/avatar.png'),
              radius: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                rating.userName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Stars(rating: rating.rating),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                DateFormat.yMd('en_US').format(
                  DateTime.fromMillisecondsSinceEpoch(rating.time),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            rating.content,
          ),
        )
      ],
    );
  }
}
