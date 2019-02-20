import 'dart:async';

import 'package:energy_berry/widgets/dimmer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // When instantiate try to connect
  ContextItem(this.device, {this.activated = false}) {
    title = device.name + " " + device.id.id;

    deviceConnection = flutterBlue.connect(device).listen((s) {
      if(s == BluetoothDeviceState.connected) {
        print("¡Conectado!");
        device.discoverServices().then((s) {
          print(s.length);
          s.forEach((sb) => print('Servicio agregado ${sb.uuid}'));
          services = s;
        });
      }
    });

    deviceConnection.onError(_onErrorHandler);
  }

  void _onErrorHandler(error) {
    print('Hubo un error ${error}');
    deviceConnection.cancel();
  }

  @override
  _ContextItemState createState() => _ContextItemState();
}

class _ContextItemState extends State<ContextItem> implements DimmerListener {

  // 0x12 0x3_
  // First 15 bits are used for BLE configuration purposes
  _writeCharacteristic(BluetoothCharacteristic c, var value) async {
    widget.device.writeCharacteristic(c, [0x12, value],
        type: CharacteristicWriteType.withResponse);
    setState(() {});
  }

  void _onTap() {
    setState(() {
      widget.activated = !widget.activated;

      widget.services.forEach((s) {
        if(s.uuid.toString().toUpperCase() == '6E400001-B5A3-F393-E0A9-E50E24DCCA9E')
          s.characteristics.forEach((c) => _writeCharacteristic(c, widget.activated ? 0x31 : 0x30));
      });
    });
  }

  void _showDialog() {
    showDialog(context: context, builder: (BuildContext context) => DimmerDialog(this));
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
      if(s.uuid.toString().toUpperCase() == '6E400001-B5A3-F393-E0A9-E50E24DCCA9E')
        s.characteristics.forEach((c) => _writeCharacteristic(c, value & 0xff));
    });
  }
}
