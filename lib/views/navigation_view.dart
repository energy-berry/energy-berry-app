import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:energy_berry/views/home.dart';
import 'package:energy_berry/views/settings.dart';
import 'package:energy_berry/views/usage.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class NavigationView extends StatefulWidget {

  @override
  _NavigationViewState createState() => _NavigationViewState();

}

class _NavigationViewState extends State<NavigationView> {
  int currentViewIndex = 0;
  static final random = new Random();

  final List<Widget> views = <Widget>[
    Home(),
    Usage(),
    Settings()
  ];

  void _onNavigationTapped(int index) {
    setState(() {
      currentViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Berry'),
      ),
      body: views[currentViewIndex],
      backgroundColor: Color.fromARGB(255, 247, 250, 253),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor : Color.fromARGB(255, 67, 111, 255)
        ),
        child: BottomNavigationBar(
          currentIndex: currentViewIndex,
          onTap: _onNavigationTapped,
            items: [
              BottomNavigationBarItem(
                  activeIcon: Image.asset(
                   "assets/img/navigation/home_active.png",
                    width: 30,
                  ),
                  icon: Image.asset(
                    "assets/img/navigation/home.png",
                    width: 30,
                  ),
                  title : Text("Home")
              ),
              BottomNavigationBarItem(
                  activeIcon: Image.asset(
                    "assets/img/navigation/bulb_active.png",
                    width: 30,
                  ),
                  icon: Image.asset(
                   "assets/img/navigation/bulb.png",
                    width: 30,
                  ),
                  title : Text("Consumo")
              ),
              BottomNavigationBarItem(
                  activeIcon: Image.asset(
                    "assets/img/navigation/settings_active.png",
                    width: 30,
                  ),
                  icon: Image.asset(
                   "assets/img/navigation/settings.png",
                    width: 30,
                  ),
                  title : Text("Ajustes")
              )
            ],
        ),
      ),
    );
  }

}
