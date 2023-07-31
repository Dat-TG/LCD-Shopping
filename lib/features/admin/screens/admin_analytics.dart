import 'package:flutter/material.dart';
import 'package:shopping/common/widgets/loader.dart';

import '../models/sales.dart';
import '../services/admin_services.dart';
import '../widgets/category_products_chart.dart';

class AdminAnalytics extends StatefulWidget {
  const AdminAnalytics({Key? key}) : super(key: key);

  @override
  State<AdminAnalytics> createState() => _AdminAnalyticsState();
}

class _AdminAnalyticsState extends State<AdminAnalytics> {
  final AdminServices adminServices = AdminServices();
  double? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Total Revenue: \$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 300,
                child: CategoryProductsChart(
                  seriesList: earnings!,
                ),
              )
            ],
          );
  }
}
