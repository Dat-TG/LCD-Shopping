import 'package:flutter/material.dart';
import 'package:shopping/constants/global_variables.dart';
import 'package:shopping/features/account/widgets/account_info.dart';
import 'package:shopping/features/account/widgets/below_appbar.dart';
import 'package:shopping/features/account/widgets/orders.dart';
import 'package:shopping/features/account/widgets/top_buttons.dart';

class AccountScreen extends StatefulWidget {
  static const String routeName = '/account-screen';
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/amazon_in.png',
                    width: 120,
                    height: 45,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.notifications_outlined),
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                )
              ],
            ),
          )),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            BelowAppBar(),
            SizedBox(
              height: 10,
            ),
            TopButtons(),
            SizedBox(
              height: 20,
            ),
            Orders(),
            SizedBox(
              height: 20,
            ),
            AccountInfo()
          ],
        ),
      ),
    );
  }
}
