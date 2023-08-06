import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/features/home/services/home_services.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/models/product.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  Product? product;
  String mainImg = '';
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfTheDay(context: context);
    if (product != null && product!.name.isNotEmpty) {
      mainImg = product!.images[0];
    }
    if (mounted) setState(() {});
  }

  void navigateToProductDetails() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
        arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return (product == null)
        ? const Loader()
        : (product!.name.isEmpty)
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: const Text(
                      'Deal of the day',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToProductDetails,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Image.network(
                            mainImg,
                            height: 235,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            '\$${product?.price}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, right: 40),
                          child: Text(
                            '${product?.description}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: product!.images
                          .map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    mainImg = e;
                                  });
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Image.network(
                                    e,
                                    fit: BoxFit.fitHeight,
                                    height: 100,
                                  ),
                                ),
                              ))
                          .toList(),
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
