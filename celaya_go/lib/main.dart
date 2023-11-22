// import 'package:celaya_go/screens/maps_screen.dart';
// import 'package:flutter/material.dart';
// //import 'package:celaya_go/routes.dart';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
      
//       title: 'Celaya Go',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MapSample(),
//     );
//   }
// }


import 'package:celaya_go/screens/OnboardingScreen.dart';
import 'package:celaya_go/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:celaya_go/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  MyApp({required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celaya Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: isFirstTime ? OnboardingPage() : MapSample(),
       home: OnboardingPage(),
       routes: getRouters(),
    );
  }
}
