import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shopping/features/account/screens/account_screen.dart';
import 'package:shopping/features/cart/screens/cart_screen.dart';
import 'package:shopping/features/home/screens/home_screen.dart';
import 'package:shopping/providers/user_provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen()
  ];

  void goToPage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLength = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: goToPage,
        items: [
          // Home
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 0
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: const Icon(Icons.home_outlined),
              ),
              label: ''),
          // Account
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 1
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: const Icon(Icons.person_outline_outlined),
              ),
              label: ''),
          // Cart
          BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: _page == 2
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth))),
                child: badges.Badge(
                    badgeContent: Container(
                      padding: const EdgeInsets.all(
                        5,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                      child: Text(
                        userCartLength.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                        padding: EdgeInsets.all(0),
                        elevation: 0,
                        badgeColor: Colors.white),
                    child: const Icon(Icons.shopping_cart_outlined)),
              ),
              label: '')
        ],
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
      ),
    );
  }
}
