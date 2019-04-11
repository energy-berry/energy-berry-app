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
//
// In our project we manage the concept of Context, which is a set
class Home extends StatefulWidget {

  static FlutterBlue flutterBlue = FlutterBlue.instance;
  Map devices = Map();
  var scanning = false;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Scan for nearby BLE devices
  void _scan() {
    if(widget.scanning) {
      print("Wait amigo.... Already scanning");
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 179, 9)
            ),
            child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, right: 8, left: 12, bottom: 8),
                child: Text(
                  "Buscando berries",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                )
              ),
            ],
          ),
        ),
        )
      );

      print("Scanning... ");

      /// Start scanning
      Home.flutterBlue.scan(
          timeout: const Duration(seconds: 4)
      ).listen((scanResult) {
        /*print('DeviceId: ${scanResult.device.id}');
        print('DeviceName: ${scanResult.device.name}');

        print('localName: ${scanResult.advertisementData.localName}');
        print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
        print('serviceData: ${scanResult.advertisementData.serviceData}');*/

        if (!widget.devices.containsKey(scanResult.device.id.id))
          widget.devices[scanResult.device.id.id] = scanResult.device;
      }).onDone(() {
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

    //BluetoothDevice testDevice = new BluetoothDevice(id: DeviceIdentifier("00000000-0000-0000-0000-987bf3767eea"), name: "Test");
    //berries.add(ContextItem(testDevice));

    widget.devices.forEach((id, d) {
      if (d.name.toString().isNotEmpty)
        berries.add(ContextItem(d));
    });

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