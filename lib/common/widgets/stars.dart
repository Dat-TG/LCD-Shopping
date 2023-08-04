import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shopping/constants/global_variables.dart';

class Stars extends StatelessWidget {
  final double rating;
  final double? itemSize;
  const Stars({super.key, required this.rating, this.itemSize});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      itemCount: 5,
      rating: rating,
      direction: Axis.horizontal,
      itemSize: (itemSize != null) ? itemSize! : 15,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: GlobalVariables.secondaryColor,
      ),
    );
  }
}
