import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/bottom_bar.dart';
import 'package:shopping/features/admin/screens/add_product_screen.dart';
import 'package:shopping/features/admin/screens/admin_screen.dart';
import 'package:shopping/features/admin/widgets/admin_bottom_bar.dart';
import 'package:shopping/features/auth/screens/auth_screen.dart';
import 'package:shopping/features/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const AuthScreen(), settings: routeSettings);
    case HomeScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const HomeScreen(), settings: routeSettings);
    case BottomBar.routeName:
      return MaterialPageRoute(
          builder: (context) => const BottomBar(), settings: routeSettings);
    case AdminBottomBar.routeName:
      return MaterialPageRoute(
          builder: (context) => const AdminBottomBar(),
          settings: routeSettings);
    case AddProductScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const AddProductScreen(),
          settings: routeSettings);
    case AdminScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const AdminScreen(), settings: routeSettings);
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: Center(child: Text('404: Not Found')),
              ),
          settings: routeSettings);
  }
}
