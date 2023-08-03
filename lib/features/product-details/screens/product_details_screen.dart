import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/stars.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/product-details/services/product_details_services.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/providers/user_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double avgRating = 0;
  double myRating = 0;
  double totalRating = 0;
  bool isValid = false;

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  void calculate() {
    totalRating = 0;
    for (int i = 0; i < widget.product.ratings!.length; i++) {
      totalRating += widget.product.ratings![i].rating;
      if (widget.product.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.ratings![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.ratings!.length;
    }
  }

  void addToCart() {
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  void checkRating(Product product) async {
    isValid = await productDetailsServices.isValidRating(
        context: context, product: product);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkRating(widget.product);
    calculate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                      height: 42,
                      child: Material(
                        borderRadius: BorderRadius.circular(7),
                        elevation: 1,
                        child: TextFormField(
                          onFieldSubmitted: naviagteToSearchScreen,
                          decoration: InputDecoration(
                              hintText: 'Search LCDShopping',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  ),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.only(top: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: const BorderSide(
                                    color: Colors.black38, width: 1),
                              )),
                        ),
                      )),
                ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                      icon: const Icon(
                        Icons.mic,
                        size: 25,
                      ),
                      onPressed: naviagteToSpeechScreen,
                    ),
                  ),
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text(
                widget.product.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            CarouselSlider(
                items: widget.product.images.map((item) {
                  return Builder(
                      builder: (BuildContext context) => Image.network(
                            item,
                            fit: BoxFit.contain,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/image_not_available.png',
                                height: 200,
                                fit: BoxFit.contain,
                              );
                            },
                          ));
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: 300,
                )),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                  text: TextSpan(
                      text: "Deal Price: ",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        text: "\$${widget.product.price}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red))
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Buy Now',
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButton(
                text: 'Add To Cart',
                backgroundColor: const Color.fromRGBO(254, 216, 19, 1),
                textColor: Colors.black,
                onTap: addToCart,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            (isValid)
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Rate The Product",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      RatingBar.builder(
                          initialRating: myRating,
                          minRating: 1,
                          allowHalfRating: true,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: GlobalVariables.secondaryColor,
                              ),
                          onRatingUpdate: (rating) {
                            productDetailsServices.rateProduct(
                                context: context,
                                product: widget.product,
                                rating: rating);
                            totalRating = totalRating - myRating + rating;
                            myRating = rating;
                            avgRating =
                                totalRating / widget.product.ratings!.length;
                            setState(() {});
                          })
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
