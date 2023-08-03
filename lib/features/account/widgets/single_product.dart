import 'package:flutter/material.dart';

class SingleProduct extends StatelessWidget {
  final String img;
  const SingleProduct({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.5),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 180,
          child: Image.network(
            img,
            fit: BoxFit.fitHeight,
            width: 180,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/image_not_available.png',
                fit: BoxFit.fitHeight,
                width: 180,
              );
            },
          ),
        ),
      ),
    );
  }
}
