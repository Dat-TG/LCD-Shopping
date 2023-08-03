import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/sales.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> seriesList;
  const CategoryProductsChart({
    Key? key,
    required this.seriesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        enableAxisAnimation: true,
        title: ChartTitle(
          text: 'Revenue Analytics',
        ),
        series: <BarSeries<Sales, String>>[
          BarSeries<Sales, String>(
            dataSource: seriesList,
            xValueMapper: (Sales sales, _) => sales.label,
            yValueMapper: (Sales sales, _) => sales.earning,
            // Enable data label
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            xAxisName: '\$',
            yAxisName: 'Category',
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}
