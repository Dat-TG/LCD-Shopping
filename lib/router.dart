import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/bottom_bar.dart';
import 'package:shopping/features/account/screens/account_screen.dart';
import 'package:shopping/features/account/screens/edit_account_screen.dart';
import 'package:shopping/features/account/screens/see_all_orders.dart';
import 'package:shopping/features/address/screens/address_screen.dart';
import 'package:shopping/features/admin/screens/add_product_screen.dart';
import 'package:shopping/features/admin/screens/admin_screen.dart';
import 'package:shopping/features/admin/screens/edit_product_screen.dart';
import 'package:shopping/features/admin/widgets/admin_bottom_bar.dart';
import 'package:shopping/features/auth/screens/auth_screen.dart';
import 'package:shopping/features/buy-now/screens/address_by_now.dart';
import 'package:shopping/features/buy-now/screens/buy_now_screen.dart';
import 'package:shopping/features/cart/screens/order_preview.dart';
import 'package:shopping/features/home/screens/category_screen.dart';
import 'package:shopping/features/home/screens/home_screen.dart';
import 'package:shopping/features/home/screens/speech_screen.dart';
import 'package:shopping/features/order-details/screens/order_details_screen.dart';
import 'package:shopping/features/product-details/screens/product_details_screen.dart';
import 'package:shopping/features/product-details/screens/rating_details_screen.dart';
import 'package:shopping/features/search/screens/search_screen.dart';
import 'package:shopping/features/wish-list/screens/wish_list_screen.dart';
import 'package:shopping/models/order.dart';
import 'package:shopping/models/rating.dart';

import 'models/product.dart';

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
    case CategoryScreen.routeName:
      final String category = routeSettings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => CategoryScreen(category: category),
          settings: routeSettings);
    case SearchScreen.routeName:
      final String searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => SearchScreen(searchQuery: searchQuery),
          settings: routeSettings);
    case ProductDetailsScreen.routeName:
      final Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(
                product: product,
              ),
          settings: routeSettings);
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailsScreen.routeName:
      final Order order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => OrderDetailsScreen(
          order: order,
        ),
      );
    case SeeAllOrders.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SeeAllOrders(),
      );
    case SpeechScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SpeechScreen(),
      );
    case EditAccountScreen.routeName:
      final EditAccountScreenArguments args =
          routeSettings.arguments as EditAccountScreenArguments;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EditAccountScreen(
          address: args.address,
          email: args.email,
          name: args.name,
          avatar: args.avatar,
        ),
      );
    case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AccountScreen(),
      );
    case EditProductScreen.routeName:
      final Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EditProductScreen(product: product),
      );
    case RatingDetailsScreen.routeName:
      final List<List<Rating>> stars =
          routeSettings.arguments as List<List<Rating>>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => RatingDetailsScreen(stars: stars),
      );
    case OrderPreview.routeName:
      double sum = double.parse(routeSettings.arguments.toString());
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => OrderPreview(sum: sum),
      );
    case BuyNowScreen.routeName:
      final Product product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => BuyNowScreen(product: product),
      );
    case AddressBuyNowScreen.routeName:
      final AddressBuyNowScreenArguments args =
          routeSettings.arguments as AddressBuyNowScreenArguments;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AddressBuyNowScreen(
          totalAmount: args.totalAmount,
          productId: args.productId,
          quantity: args.quantity,
        ),
      );
    case WishListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const WishListScreen(),
      );
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: Center(child: Text('404: Not Found')),
              ),
          settings: routeSettings);
  }
}
