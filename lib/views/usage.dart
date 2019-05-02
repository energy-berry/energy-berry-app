import 'package:energy_berry/widgets/h1.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Usage extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  Usage(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory Usage.withSampleData() {
    return new Usage(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView(children: <Widget>[
        H1("Consumo de Mayo"),
        new Container(
          height: 200,
          width: 100,
          child:new charts.LineChart(seriesList,
              animate: animate,
              defaultRenderer: new charts.LineRendererConfig(includePoints: true)
          )
        ),
        H1("Consumo de Abril"),
        new Container(
            height: 200,
            width: 100,
            child:new charts.LineChart(seriesList,
                animate: animate,
                defaultRenderer: new charts.LineRendererConfig(includePoints: true)
            )
        )
      ])
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
