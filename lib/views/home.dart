import 'package:energy_berry/widgets/context_picker.dart';
import 'package:energy_berry/widgets/h1.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var chart = Container(
        height: 160,
        margin: EdgeInsets.only(left: 12, right: 12),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
            ],
            color: Colors.white));


    return ListView(children: <Widget>[
      H1("Consumo del mes"),
      chart,

      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          H1("Contexto", marginTop: 36),
          Expanded(
            child: Container(
              alignment: Alignment(1,0),
              child: ContextPicker(),
              margin: EdgeInsets.only(top: 28, right: 12)
            )
          )
        ],
      ),

    ]);
  }
}
