import 'package:energy_berry/views/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(255, 255, 48, 84)
    ));

    return MaterialApp(
      title: 'Energy Berry',
      theme: ThemeData(
        primaryColor: Colors.white,
        bottomAppBarColor: Color.fromARGB(255, 223, 230, 233)
      ),
      home: NavigationView(),
    );
  }
}
