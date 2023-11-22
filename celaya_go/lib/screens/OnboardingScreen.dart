import 'package:celaya_go/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';



class OnboardingPage extends StatelessWidget {
  final List<Widget> onboardingPages = [
    // Puedes personalizar cada página de onboarding según tus necesidades
    OnboardingCard(
      title: "Bienvenido a Celaya Go",
      subtitle: "Descubre la emoción de la Fórmula 1",
      image: AssetImage("assets/onboarding_image_1.png"),
    ),
    OnboardingCard(
      title: "Explora Equipos",
      subtitle: "Conoce más sobre los equipos de F1",
      image: AssetImage("assets/onboarding_image_2.png"),
    ),
    OnboardingCard(
      title: "¡Comienza a Navegar!",
      subtitle: "Desliza para explorar",
      image: AssetImage("assets/onboarding_image_3.png"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: onboardingPages,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.map_sharp),
        label: Text('Siguiente'),
        onPressed: () {
          // Navegar a la pantalla principal después del onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class OnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ImageProvider image;

  OnboardingCard({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            subtitle,
            style: TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Image(image: image),
        ],
      ),
    );
  }
}

