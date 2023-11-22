import 'package:celaya_go/screens/OnboardingScreen.dart';
import 'package:celaya_go/screens/dashboard_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:celaya_go/screens/maps_screen.dart';
import 'package:celaya_go/screens/turismo_screen.dart';

Map<String,WidgetBuilder> getRouters(){
  return{
    '/map' : (BuildContext context) => const MapSample(),
    '/turismo' : (BuildContext context) => TurismoScreen(),
     '/onboar' : (BuildContext context) => OnboardingPage(),
     '/dash' : (BuildContext context) => DashboardScreen(),
    //'/namerout' : (BuildContext context) => classname(),
    //'/namerout' : (BuildContext context) => classname(),
    //'/namerout' : (BuildContext context) => classname(),
    //'/namerout' : (BuildContext context) => classname(),
  };
}