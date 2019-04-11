import 'package:flutter/material.dart';

// Widget:

// Text for important things
// It's the equivalent of html h1's
class H1 extends StatelessWidget {

  var title;

  double marginLeft;
  double marginRight;
  double marginBottom;
  double marginTop;

  H1(this.title, {this.marginLeft = 12, this.marginRight = 12, this.marginBottom = 12,
      this.marginTop = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft, right: marginRight, top: marginTop, bottom: marginBottom),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
    );
  }
}
