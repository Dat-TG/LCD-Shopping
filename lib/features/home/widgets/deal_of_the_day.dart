import 'package:flutter/material.dart';

class DealOfTheDay extends StatelessWidget {
  const DealOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: const Text(
            'Deal of the day',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Image.network(
            'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YW5pbWV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60',
            height: 235,
            fit: BoxFit.fitHeight,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15, top: 5),
          child: const Text(
            '\$999.0',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
          child: const Text(
            'Mot san pham rat la vip pro',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Image.network(
                'https://plus.unsplash.com/premium_photo-1664442394433-5e555096103f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDE1fHhIeFlUTUhMZ09jfHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              Image.network(
                'https://images.unsplash.com/photo-1687525023557-9da27d33b708?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHx0b3BpYy1mZWVkfDI3fHhIeFlUTUhMZ09jfHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              Image.network(
                'https://images.unsplash.com/photo-1689240766231-6d9b33f1a899?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0OXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              Image.network(
                'https://images.unsplash.com/photo-1688990608946-d015fa39cd3b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0OHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              Image.network(
                'https://images.unsplash.com/photo-1689198923121-c9df32e192eb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1OHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              ),
              Image.network(
                'https://plus.unsplash.com/premium_photo-1661814303621-c6fa0772fe6a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyMDV8fHxlbnwwfHx8fHw%3D&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.fitHeight,
                height: 100,
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Text(
            'See all',
            style: TextStyle(fontSize: 16, color: Colors.cyan[800]),
          ),
        )
      ],
    );
  }
}
