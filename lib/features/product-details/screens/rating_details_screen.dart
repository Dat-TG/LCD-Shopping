import 'package:flutter/material.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/product-details/widgets/review.dart';
import 'package:shopping/models/rating.dart';

class RatingDetailsScreen extends StatefulWidget {
  static const String routeName = '/rating-details';
  final List<List<Rating>> stars;
  const RatingDetailsScreen({super.key, required this.stars});

  @override
  State<RatingDetailsScreen> createState() => _RatingDetailsScreenState();
}

class _RatingDetailsScreenState extends State<RatingDetailsScreen> {
  List<Rating> list = [];
  int choice = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rating Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.appBarGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        choice = 0;
                        list = [];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: (choice == 0)
                              ? GlobalVariables.selectedNavBarColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: choice != 0
                              ? Border.all(color: Colors.black12, width: 1)
                              : Border.all(width: 0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Text(
                          'Tất cả',
                          style: TextStyle(
                              color: choice == 0 ? Colors.white : Colors.black,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                for (int i = 5; i >= 1; i--)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          choice = i;
                          list = widget.stars[i - 1];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (choice == i)
                                ? GlobalVariables.selectedNavBarColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: choice != i
                                ? Border.all(color: Colors.black12, width: 1)
                                : Border.all(width: 0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '$i ',
                                style: TextStyle(
                                    color: choice == i
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16),
                              ),
                              Icon(
                                Icons.star,
                                color:
                                    choice == i ? Colors.white : Colors.black,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 5,
            color: Colors.black12,
            width: double.infinity,
          ),
          const SizedBox(
            height: 20,
          ),
          (choice == 0)
              ? (widget.stars[5].isEmpty)
                  ? const Text('There are no reviews')
                  : Column(
                      children: widget.stars[5]
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Review(rating: e),
                              ))
                          .toList())
              : list.isEmpty
                  ? const Text('There are no reviews')
                  : Column(
                      children: list
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Review(rating: e),
                              ))
                          .toList(),
                    ),
        ]),
      ),
    );
  }
}
