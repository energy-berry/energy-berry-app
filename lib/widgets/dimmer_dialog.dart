import 'package:energy_berry/widgets/h1.dart';
import 'package:energy_berry/widgets/h2.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class DimmerDialog extends StatefulWidget {

  int value = 100;
  DimmerListener listener;
  DialogListener dialogListener;
  DateTime date;

  DimmerDialog(this.listener, this.dialogListener)
  {
    date = new DateTime.now();
  }

  @override
  _DimmerDialogState createState() => _DimmerDialogState();
}

class _DimmerDialogState extends State<DimmerDialog> {

  DateTime dateNow;

  void _updateValue(newValue) {
    widget.listener.onDimmerChanged(newValue.round());
    setState(() => widget.value = newValue.round());
  }

  @override
  Widget build(BuildContext context) {
    dateNow = new DateTime.now();
    dateNow.add(Duration(hours: -6)); // Remove Mexico City offset

    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
        ), //this right here
        child: Container(
          height: 360.0,
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
                divisions: 20,
                min: 0,
                max: 100,
                value: widget.value.toDouble()
              ),
              Padding(padding: EdgeInsets.only(top: 24)),

              H1("Programar dispositivo"),

              Container(
                child: DateTimePickerFormField(
                  inputType: InputType.time,
                  format: DateFormat("HH:mm"),
                  initialDate: new DateTime.now(),
                  editable: false,
                  decoration: InputDecoration(
                      labelText: 'Hora', hasFloatingPlaceholder: false),
                  onChanged: (dt) => setState(() {
                    widget.date = new DateTime(dateNow.year, dateNow.month, dateNow.day, dt.hour, dt.minute, dt.second);
                  }),
                ),
                padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
              ),
              
              FlatButton(
                  onPressed: () {
                    widget.dialogListener.onDialogOk(widget.date, widget.value);
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

abstract class DialogListener {
  void onDialogOk(DateTime time, int dimmerValue);
}