import 'package:energy_berry/views/home.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {

  @override
  _NavigationViewState createState() => _NavigationViewState();

}

class _NavigationViewState extends State<NavigationView> {
  int currentViewIndex = 0;

  final List<Widget> views = <Widget>[
    Home(),
    Home(),
    Home()
  ];

  void _onNavigationTapped(int index) {
    setState(() {
      currentViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[currentViewIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor : Color.fromARGB(255, 255, 48, 84)
        ),
        child: BottomNavigationBar(
            currentIndex: currentViewIndex,
            onTap: _onNavigationTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title : Text("Home")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline),
                  title : Text("Consumo")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title : Text("Perfil")
              )
            ]),
      ),
    );
  }

}
