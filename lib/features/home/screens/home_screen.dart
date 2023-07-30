import 'package:flutter/material.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/home/widgets/address_box.dart';
import 'package:shopping/features/home/widgets/carousel_images.dart';
import 'package:shopping/features/home/widgets/deal_of_the_day.dart';
import 'package:shopping/features/home/widgets/top_categories.dart';
import 'package:shopping/features/search/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void naviagteToSearchScreen(String searchQuery) {
    Navigator.pushNamed(context, SearchScreen.routeName,
        arguments: searchQuery);
  }

  void naviagteToSpeechScreen() {
    Navigator.pushNamed(context, SpeechScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(left: 15),
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
        body: const SingleChildScrollView(
          child: Column(
            children: [
              AddressBox(),
              SizedBox(
                height: 10,
              ),
              TopCategories(),
              SizedBox(
                height: 10,
              ),
              CarouselImages(),
              DealOfTheDay()
            ],
          ),
        ));
  }
}
