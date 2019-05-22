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
  var iconName = "bulb.png";
  var index = 0;

  // BLE data
  BluetoothDevice device;

  ContextItem(this.index, this.device, this.title, this.iconName, {this.activated = false});

  @override
  _ContextItemState createState() => _ContextItemState();
}

class _ContextItemState extends State<ContextItem> implements DimmerListener, DialogListener {

  // 0x12 0x3_
  // First 15 bits are used for BLE configuration purposes
  _writeCharacteristic(BluetoothCharacteristic c, var value) async {
    print("Writing value");
    print("Info: ${c.uuid}");

    widget.device.writeCharacteristic(c, value);
    setState(() {});
  }

  void _onTap() {
    setState(() {
      Home.services.forEach((s) {
        if(s.uuid.toString() == '00001805-0000-1000-8000-00805f9b34fb') {
          widget.activated = !widget.activated;
          var info = "${widget.index}|${widget.activated ? 0x00 : 0x64}|NOW";
          print(info);

          s.characteristics.forEach((c) => _writeCharacteristic(c, utf8.encode(info)));
        }
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
                      "assets/img/navigation/${widget.iconName}",
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
    Home.services.forEach((s) {
      if(s.uuid.toString() == '00001805-0000-1000-8000-00805f9b34fb') { // Current Time Service
        var info = "${widget.index}|$value|NOW";
        print(info);

        s.characteristics.forEach((c) =>
            _writeCharacteristic(c, [value & 0xff]));
      }
    });
  }

  @override
  void onDialogOk(DateTime time, int dimmerValue) {
    int epoch = (time.millisecondsSinceEpoch/1000).floor(); // Convert to seconds

    Home.services.forEach((s) {
      if(s.uuid.toString() == '00001805-0000-1000-8000-00805f9b34fb') { // Current Time Service
        var info = "${widget.index}|$dimmerValue|$epoch";
        print(info);

        s.characteristics.forEach((c) =>
            _writeCharacteristic(c, utf8.encode(epoch.toString())));
      }
    });
  }

}
