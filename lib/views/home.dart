import 'dart:async';
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

  FlutterBlue flutterBlue = FlutterBlue.instance;
  var scanning = false;
  var berries = <Widget>[]; // List to store context devices. i.e fan, microwave, light bulb, etc.

  // BLE data
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  static List<BluetoothService> services = new List();
  BluetoothDevice enerbyBerryDevice;
  BluetoothDeviceState stateBlue = null;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _connectToDevice() {
    if(widget.stateBlue != BluetoothDeviceState.connected) {
      print("Trying to connect...");

      widget.deviceConnection = widget.flutterBlue.connect(widget.enerbyBerryDevice, autoConnect: false).listen((s) {
        widget.stateBlue = s;

        if(s == BluetoothDeviceState.connected) {
          print("Conected!");
          widget.enerbyBerryDevice.discoverServices().then((s) {
            Home.services.clear();
            print(s.length);
            s.forEach((sb) {
              print('Service detected ${sb.uuid}');

              sb.characteristics.forEach((sc) => print("Characteristic ${sc.uuid}"));
            });
            Home.services = s;
          });
        }
      });

     //widget.deviceConnection.onError(widget._onErrorHandler);

      widget.enerbyBerryDevice.onStateChanged().listen((newState) {
        print("Device State changed: $newState");
      });
    } else {

      // Remove all value changed listeners
      /*widget.enerbyBerryDevice.services.forEach((uuid, sub) => sub.cancel());
      valueChangedSubscriptions.clear();
      deviceStateSubscription?.cancel();
      deviceStateSubscription = null;
      widget.deviceConnection?.cancel();
      widget.deviceConnection = null;*/

      setState(() {
        widget.enerbyBerryDevice = null;
      });
      print("Device already connected");
    }
  }

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
                  "Conectando...",
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
      widget.enerbyBerryDevice = null;

      /// Start scanning
      widget.flutterBlue.scan(
          timeout: const Duration(seconds: 2)
      ).listen((scanResult) {
        if(scanResult.device.name.isNotEmpty) {
          print('DeviceId: ${scanResult.device.id}');
          print('DeviceName: ${scanResult.device.name}');
        }

        if(scanResult.device.name == "Enegy Berry Module") {
          widget.enerbyBerryDevice = scanResult.device;
          _connectToDevice();
          setState(() {
            widget.berries.clear();
            widget.berries.add(ContextItem(0, widget.enerbyBerryDevice, "Luz", "bulb.png"));
            widget.berries.add(ContextItem(1, widget.enerbyBerryDevice, "Ventilador", "fan.png"));
            widget.berries.add(ContextItem(2, widget.enerbyBerryDevice, "Microondas", "microwave.png"));

            widget.scanning = false;
          });
        }

        /*print('localName: ${scanResult.advertisementData.localName}');
        print('manufacturerData: ${scanResult.advertisementData.manufacturerData}');
        print('serviceData: ${scanResult.advertisementData.serviceData}');*/

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

    var grid = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,

      children: widget.berries
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
              child: Text("Conectar a Berry Box")
          )
      ),

      grid
    ]);
  }
}