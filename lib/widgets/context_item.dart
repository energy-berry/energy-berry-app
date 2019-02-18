import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

// Widget:
//
// Card to manipulate an item in different home contexts
class ContextItem extends StatefulWidget {
  var title;
  var activated;

  ContextItem(this.title, {this.activated = false});

  @override
  _ContextItemState createState() => _ContextItemState();
}

class _ContextItemState extends State<ContextItem> {

  void _onTap() {
    var title = widget.title.toString();
    var activated = widget.activated.toString();

    print("$title esta en $activated");

    setState(() {
      widget.activated = !widget.activated;
    });
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
}
