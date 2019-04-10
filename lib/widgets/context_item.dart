import 'dart:async';

import 'package:energy_berry/views/home.dart';
import 'package:energy_berry/widgets/dimmer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

// Widget:
//
// Card to manipulate an item in different home contexts
class ContextItem extends StatefulWidget {

  // Device state and info
  var activated;
  var title = "No name";

  // BLE data
  StreamSubscription<BluetoothDeviceState> deviceConnection;
  List<BluetoothService> services = new List();
  BluetoothDevice device;
  BluetoothDeviceState stateBlue = null;

  // When instantiate try to connect
  ContextItem(this.device, {this.activated = false}) {
    Home.flutterBlue.setLogLevel(LogLevel.emergency);
    title = device.name + " " + device.id.id;
  }

  void _onErrorHandler(error) {
    print('Hubo un error :c ${error}');
    //deviceConnection.cancel();
    /*device.discoverServices().then((s) {
      services.clear();
      print(s.length);
      s.forEach((sb) {
        // print('Servicio agregado ${sb.uuid}');

        //sb.characteristics.forEach((sc) => print("Caracteristica ${sc.uuid}"));
      });
      services = s;
    });*/
  }

  @override
  _ContextItemState createState() => _ContextItemState();
}

class _ContextItemState extends State<ContextItem> implements DimmerListener, DialogListener {

  // 0x12 0x3_
  // First 15 bits are used for BLE configuration purposes
  _writeCharacteristic(BluetoothCharacteristic c, var value) async {
    print("Writing value");
    print("Info: ${c.uuid}");

    c.descriptors.forEach((des) => print("descru: ${des.uuid}"));

    widget.device.writeCharacteristic(c, value);
    setState(() {});
  }

  void _onTap() {
    if(widget.stateBlue != BluetoothDeviceState.connected) {
      print("Intentando conectar");

      widget.deviceConnection = Home.flutterBlue.connect(widget.device, autoConnect: false).listen((s) {
        widget.stateBlue = s;
        print("npi ${s}");

        if(s == BluetoothDeviceState.connected) {
          print("¡Conectado!");
          widget.device.discoverServices().then((s) {
            widget.services.clear();
            print(s.length);
            s.forEach((sb) {
              print('Servicio agregado ${sb.uuid}');

              sb.characteristics.forEach((sc) => print("Caracteristica ${sc.uuid}"));
            });
            widget.services = s;
          });
        }
      });

      widget.deviceConnection.onError(widget._onErrorHandler);

      widget.device.onStateChanged().listen((s) {
        print("Imprimio algo $s");
      });
    } else {
      setState(() {
        widget.activated = !widget.activated;

        widget.services.forEach((s) {
          print("Si hay servicio ${s.uuid}");

          if(s.uuid.toString() == '0000180f-0000-1000-8000-00805f9b34fb')
            s.characteristics.forEach((c) => _writeCharacteristic(c, [widget.activated ? 0x00 : 0x64]));
        });
      });
      // Remove all value changed listeners
      /*widget.services..forEach((uuid, sub) => sub.cancel());
      valueChangedSubscriptions.clear();
      deviceStateSubscription?.cancel();
      deviceStateSubscription = null;
      deviceConnection?.cancel();
      deviceConnection = null;
      setState(() {
        device = null;
      });*/
    }
  }

  void _showDialog() {
    showDialog(context: context, builder: (BuildContext context) => DimmerDialog(this, this));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(12),
        width: 150,
        child: Card(
          color: widget.activated ? Color.fromARGB(255, 67, 111, 255) : Colors.white,
          child: InkWell(
            onTap: _onTap,
            onLongPress: _showDialog,
            splashColor: Color.fromARGB(100, 67, 111, 255),
            child: Container(
              padding: EdgeInsets.all(6),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment(0, 0),
                      height: 40,
                      child: Text(widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.activated ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                          ))),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/img/navigation/bulb.png",
                      color: widget.activated ? Colors.white : Colors.black,
                      width: 60,
                    ),
                  )
                ],
              ),
        ))));
  }

  @override
  void onDimmerChanged(int value) {
    widget.services.forEach((s) {
      if(s.uuid.toString() == '0000180f-0000-1000-8000-00805f9b34fb') // Battery Service
        s.characteristics.forEach((c) => _writeCharacteristic(c, [value & 0xff]));
    });
  }

  @override
  void onDialogOk(DateTime time) {
    var str = time.millisecondsSinceEpoch.toString();

    widget.services.forEach((s) {
      if(s.uuid.toString() == '00001805-0000-1000-8000-00805f9b34fb') // Current Time Service
        s.characteristics.forEach((c) => _writeCharacteristic(c, utf8.encode(str)));
    });
  }

}
