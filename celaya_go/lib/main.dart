import 'package:celaya_go/screens/maps_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celaya Go',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}

/*import 'package:celaya_go/screens/maps_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapSample()
    );
  }
}*/
