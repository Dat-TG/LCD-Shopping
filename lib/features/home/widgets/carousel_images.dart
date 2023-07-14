import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopping/constants/global_variables.dart';

class CarouselImages extends StatelessWidget {
  const CarouselImages({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: GlobalVariables.carouselImages.map((item) {
          return Builder(
              builder: (BuildContext context) => Image.network(
                    item,
                    fit: BoxFit.cover,
                    height: 200,
                  ));
        }).toList(),
        options: CarouselOptions(viewportFraction: 1, height: 200));
  }
}
