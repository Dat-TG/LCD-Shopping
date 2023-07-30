import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/home/widgets/address_box.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/features/search/services/search_services.dart';
import 'package:shopping/features/search/widgets/searched_product.dart';
import 'package:shopping/models/product.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? productList;
  final SearchServices searchServices = SearchServices();

  fetchSearchProducts() async {
    productList = await searchServices.fetchProductsBySearchQuery(
        context: context, searchQuery: widget.searchQuery);
    setState(() {});
  }

  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushReplacementNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchSearchProducts();
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
                          initialValue: widget.searchQuery,
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
      body: Column(
        children: [
          const AddressBox(),
          const SizedBox(
            height: 10,
          ),
          productList == null
              ? const Loader()
              : productList!.isEmpty
                  ? const Center(
                      child: Text('There are no products'),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: productList!.length,
                          itemBuilder: (context, index) {
                            final product = productList![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProductDetailsScreen.routeName,
                                    arguments: product);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: SearchedProduct(
                                  product: product,
                                ),
                              ),
                            );
                          }),
                    ),
        ],
      ),
    );
  }
}
