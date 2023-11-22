//import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:celaya_go/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'maps_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionSaved');
    //Navigator.pushReplacementNamed(context, '/map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenidos :)'),
      ),
      drawer: createDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget createDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/400'),
            ),
            accountName: Text('Joseph'),
            accountEmail: Text('Maldonadojose@gmail.com'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Map'),
            onTap: () => Navigator.pushNamed(context, '/map'),
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active),
            title: Text('Turismo'),
            onTap: () => Navigator.pushNamed(context, '/turismo'),
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('Por si algo mas se me ocurre'),
            onTap: () => Navigator.pushNamed(context, '/turismo'),
          ),
        ],
      ),
    );
  }
}
