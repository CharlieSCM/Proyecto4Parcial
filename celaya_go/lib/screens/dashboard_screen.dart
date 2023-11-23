import 'package:celaya_go/firebase/auth_with_google.dart';
import 'package:celaya_go/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:celaya_go/assets/global_values.dart';
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

  final FirebaseUser _user = FirebaseUser();
  final AuthServiceGoogle _auth = AuthServiceGoogle();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user.user = _auth.user;
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
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: _user.imageUrl != null
                    ? NetworkImage(_user.imageUrl!)
                    : NetworkImage('https://i.pravatar.cc/300'),
              ),
              accountName: _user.name != null
                  ? Text(_user.name!)
                  : Text('Buenas tardes'),
              accountEmail: _user.email != null
                  ? Text(_user.email!)
                  : Text('Bienvenido')),
          ListTile(
            leading: Icon(Icons.map),
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
          DayNightSwitcher(
            isDarkModeEnabled: globalValues.flagTheme.value,
            onStateChanged: (isDarkModeEnabled) {
              globalValues.flagTheme.value = isDarkModeEnabled;
              globalValues().saveValue(isDarkModeEnabled);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout), // Ícono de cerrar sesión
            title: Text('Cerrar sesión'),
            onTap: () {
              logout(); // Llama a la función logout al hacer clic en "Cerrar sesión"
              _handleLogOut();
              // _logoutFB();
            },
          
        )
        ],
      ),
    );
  
  }

void _handleLogOut() async {
  await _auth.signOutGoogle();
  Navigator.pushReplacementNamed(context, '/logout');
  setState(() {
    _user.user = _auth.user;
    Navigator.pushNamed(context, '/logout');
  });
}

void _handleLogin() async {
  await _auth.signInGoogle();
  setState(() {
    _user.user = _auth.user;
  });
}
}

