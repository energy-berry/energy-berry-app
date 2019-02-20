import 'dart:collection';

import 'package:energy_berry/widgets/context_item.dart';
import 'package:energy_berry/widgets/context_picker.dart';
import 'package:energy_berry/widgets/h1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


// View:
//
// Show general information about energy berry
// like energy usage, contexts and context manipulation
class Home extends StatefulWidget {

  FlutterBlue flutterBlue = FlutterBlue.instance;
  Map devices = Map();
  var scanning = false;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Scan for nearby BLE devices
  void _scan() {
    if(widget.scanning) {
      print("Already scanning");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.all(8),
                child: Text("Buscando berries")
              ),
            ],
          ),
        ),
        )
      );

      print("Escaneando");

      /// Start scanning
      widget.flutterBlue.scan(
          timeout: const Duration(seconds: 3)
      ).listen((scanResult) {
        /*print('DeviceId: ${scanResult.device.id}');
        print('DeviceName: ${scanResult.device.name}');

        print('localName: ${scanResult.advertisementData.localName}');
        print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
        print('serviceData: ${scanResult.advertisementData.serviceData}');*/

        if (!widget.devices.containsKey(scanResult.device.id.id))
          widget.devices[scanResult.device.id.id] = scanResult.device;
      }).onDone(() {
        widget.devices["Pruebas"] = BluetoothDevice(id: DeviceIdentifier("Pruebas"), name: "222");

        setState(() {
          Navigator.pop(context); //pop dialog
          widget.scanning = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var berries = <Widget>[]; // List to store context devices

    var chart = Container(
        height: 210,
        margin: EdgeInsets.only(left: 12, right: 12),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/chart.png"),
                fit: BoxFit.cover,
                alignment: Alignment(0, -1)
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)
            ],
            color: Colors.white)
    );

    widget.devices.forEach((id, d) =>
      berries.add(ContextItem(d))
    );

    var grid = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,

      children: berries
    );


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
                  margin: EdgeInsets.only(top: 24, right: 12)
              )
          )
        ],
      ),

      Container(
        alignment: Alignment.center,
        child: RaisedButton(
            onPressed: _scan,
            child: Text("Buscar berries")
        )
      ),

      grid
    ]);
  }
}