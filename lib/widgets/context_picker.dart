import 'package:flutter/material.dart';

// This is the type used by the popup menu below.
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

// Widget:
//
// Picker to select home context
class ContextPicker extends StatefulWidget {
  @override
  _ContextPickerState createState() => _ContextPickerState();
}

class _ContextPickerState extends State<ContextPicker> {

  var _selection;

  @override
  Widget build(BuildContext context) {
    var menu = PopupMenuButton<WhyFarther>(
      tooltip: "Seleccionar contexto",
      onSelected: (WhyFarther result) {
        setState(() {
          _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: Text('Cocina'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Text('Comedor'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Cochera'),
        )
      ],
    );

    return menu;
  }
}
