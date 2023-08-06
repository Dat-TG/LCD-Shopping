import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shopping/common/widgets/custom_button.dart';
import 'package:shopping/common/widgets/custom_textfield.dart';
import 'package:shopping/common/widgets/stars.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/buy-now/screens/buy_now_screen.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/product-details/screens/rating_details_screen.dart';
import 'package:shopping/features/product-details/services/product_details_services.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/models/product.dart';
import 'package:shopping/models/rating.dart';
import 'package:shopping/models/user.dart';
import 'package:shopping/providers/user_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<List<Rating>> stars = [[], [], [], [], [], []];
  double avgRating = 0;
  double myRating = 0;
  double totalRating = 0;
  bool isValid = false;
  bool haveRated = false;
  String myComment = '';
  final TextEditingController _contentController = TextEditingController();

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  void navigateToBuyNowScreen(Product product) {
    Navigator.pushNamed(context, BuyNowScreen.routeName, arguments: product);
  }

  void calculate() {
    totalRating = 0;
    for (int i = 0; i < widget.product.ratings!.length; i++) {
      totalRating += widget.product.ratings![i].rating;
      stars[(widget.product.ratings![i].rating - 1).toInt()]
          .add(widget.product.ratings![i]);
      if (widget.product.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.ratings![i].rating;
        myComment = widget.product.ratings![i].content;
        haveRated = true;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.ratings!.length;
    }
  }

  void addToCart() {
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  void addToWishList(bool isFavorite) {
    productDetailsServices.addToWishList(
        context: context, product: widget.product, isFavorite: isFavorite);
  }

  void checkRating(Product product) async {
    isValid = await productDetailsServices.isValidRating(
        context: context, product: product);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    stars[5] = widget.product.ratings!;
    checkRating(widget.product);
    calculate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).user;
    bool isFavorite = false;
    for (int i = 0; i < user.wishList.length; i++) {
      if (user.wishList[i] == widget.product.id) {
        isFavorite = true;
        break;
      }
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.black12, width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded),
                    Text('Chat now'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  navigateToBuyNowScreen(widget.product);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Buy now'),
              ),
              ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              IconButton(
                tooltip: 'Add to wish list',
                onPressed: () => addToWishList(isFavorite),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFavorite
                      ? GlobalVariables.selectedNavBarColor
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
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
            (isValid)
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            (haveRated) ? "Your Rating" : "Rate The Product",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        (haveRated)
                            ? Stars(
                                rating: myRating,
                                itemSize: 40,
                              )
                            : RatingBar.builder(
                                initialRating: myRating,
                                minRating: 1,
                                allowHalfRating: false,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: GlobalVariables.secondaryColor,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    myRating = rating;
                                  });
                                },
                              ),
                        (haveRated)
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: const Border.fromBorderSide(
                                    BorderSide(
                                        color: Colors.black38,
                                        width: 1,
                                        strokeAlign: 1),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(myComment))
                            : CustomTextField(
                                controller: _contentController,
                                hint: 'Write your comment',
                                maxLines: 3,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        (haveRated)
                            ? CustomButton(
                                text: 'Edit Review',
                                onTap: () {
                                  setState(() {
                                    haveRated = false;
                                    _contentController.text = myComment;
                                  });
                                },
                              )
                            : CustomButton(
                                text: 'Send Review',
                                onTap: () {
                                  productDetailsServices.rateProduct(
                                      context: context,
                                      product: widget.product,
                                      rating: myRating,
                                      content: _contentController.text);
                                },
                              )
                      ],
                    ),
                  )
                : const SizedBox(),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ratings and reviews',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RatingDetailsScreen.routeName,
                              arguments: stars);
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              avgRating.toString(),
                              style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stars(rating: avgRating),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                widget.product.ratings!.length.toString(),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (int i = 4; i >= 0; i--)
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text((i + 1).toString()),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      width: 200,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: LinearProgressIndicator(
                                          color: GlobalVariables
                                              .selectedNavBarColor,
                                          backgroundColor: Colors.black12,
                                          value: (widget
                                                  .product.ratings!.isNotEmpty)
                                              ? stars[i].length /
                                                  widget.product.ratings!.length
                                              : 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
