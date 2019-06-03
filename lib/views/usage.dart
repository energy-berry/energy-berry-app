import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_berry/widgets/h1.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Usage extends StatefulWidget {
  List<LinearUsage> chartData = List<LinearUsage>();
  int counter = 1;

  List<charts.Series<LinearUsage, num>> list = [];

  @override
  State<StatefulWidget> createState() {
    return _UsageState();
  }
}

class _UsageState extends State<Usage> {

  /**
   * Fetch data from firestore
   */
  void _fetchData() {
    Firestore.instance
        .collection('energy_measure/berry_hwav/real_time')
        .snapshots()
        .listen((data) {
            data.documents.forEach(
               (doc) {
                 print(widget.counter);
                 print(doc["hola"]);
                 //widget.chartData.add(new LinearUsage(widget.counter++, doc["hola"]));
               });

            /*setState(() {
              widget.list.add(new charts.Series<LinearUsage, int>(
                id: 'Sales',
                colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
                domainFn: (LinearUsage usage, _) => usage.day,
                measureFn: (LinearUsage usage, _) => usage.watts,
                fillColorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
                labelAccessorFn: (LinearUsage usage, _) => usage.watts.toString(),
                data: widget.chartData,
              ));
            });*/
        });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.counter == 1)
      _fetchData();

    return Container(
        padding: EdgeInsets.all(8),
        child: ListView(children: <Widget>[
          H1("Consumo de Mayo"),
          new Container(
              height: 200,
              width: 100,
              child:new charts.LineChart(widget.list,
                  animate: true,
                  defaultRenderer: new charts.LineRendererConfig(includePoints: true)
              )
          ),
          H1("Consumo de Abril"),
          new Container(
              height: 200,
              width: 100,
              child:new charts.LineChart(widget.list,
                  animate: true,
                  defaultRenderer: new charts.LineRendererConfig(includePoints: true)
              )
          )
        ])
    );
  }
}

/// Sample linear data type.
class LinearUsage {
  final int day;
  final int watts;

  LinearUsage(this.day, this.watts);
}
