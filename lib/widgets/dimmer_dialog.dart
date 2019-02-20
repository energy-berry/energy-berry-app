import 'package:energy_berry/widgets/h1.dart';
import 'package:energy_berry/widgets/h2.dart';
import 'package:flutter/material.dart';

class DimmerDialog extends StatefulWidget {

  int value = 100;
  DimmerListener listener;

  DimmerDialog(this.listener);

  @override
  _DimmerDialogState createState() => _DimmerDialogState();
}

class _DimmerDialogState extends State<DimmerDialog> {

  void _updateValue(newValue) {
    widget.listener.onDimmerChanged(newValue.round());
    setState(() => widget.value = newValue.round());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          height: 300.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              H1("Regulador de intensidad"),
              H2(
                "Valor actual: ${widget.value} %",
                marginTop: 0,
              ),
              Padding(padding: EdgeInsets.only(top: 48)),
              Slider(
                onChanged: _updateValue,
                activeColor: Colors.amber,
                inactiveColor: Colors.black12,
                label: '${widget.value} %',
                divisions: 10,
                min: 0,
                max: 100,
                value: widget.value.toDouble()
              ),
              Padding(padding: EdgeInsets.only(top: 24)),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 18.0),
                  ))
            ],
          ),
        ));
  }
}

abstract class DimmerListener {
  void onDimmerChanged(int value);
}