import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TurismoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Celaya Guanajuato'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Lugares Turísticos', [
              _buildCarouselSlider([
                {
                  'image': 'assets/image1.jpeg',
                  'description': 'La bola del agua'
                },
                {
                  'image': 'assets/image2.jpeg',
                  'description': 'Jardin'
                },
                {
                  'image': 'assets/image3.jpeg',
                  'description': 'Museo'
                },
                {
                  'image': 'assets/image4.jpeg',
                  'description': 'Estadio'
                },
              ]),
            ]),
            _buildSection('Hoteles', [
              _buildCarouselSlider([
                {
                  'image': 'assets/hotel_1.jpg',
                  'description': 'Descripción del hotel 1'
                },
                {
                  'image': 'assets/hotel_2.jpg',
                  'description': 'Descripción del hotel 2'
                },
                {
                  'image': 'assets/hotel_3.jpg',
                  'description': 'Descripción del hotel 3'
                },
              ]),
            ]),
            _buildSection('Restaurantes', [
              _buildCarouselSlider([
                {
                  'image': 'assets/image5.jpeg',
                  'description': 'Chino/Sticker-Man House'
                },
                {
                  'image': 'assets/image6.jpeg',
                  'description': 'Quien sabde donde'
                },
                {
                  'image': 'assets/image7.jpeg',
                  'description': 'Quien sabde donde'
                },
                {
                  'image': 'assets/image8.jpeg',
                  'description': 'Quien sabde donde'
                },
              ]),
            ]),
            _buildSection('Lugares no Seguros', [
              _buildCarouselSlider([
                {
                  'image': 'assets/image5.jpeg',
                  'description': 'Chino/Sticker-Man House'
                },
                {
                  'image': 'assets/image6.jpeg',
                  'description': 'Quien sabde donde'
                },
                {
                  'image': 'assets/image7.jpeg',
                  'description': 'Quien sabde donde'
                },
                {
                  'image': 'assets/image8.jpeg',
                  'description': 'Quien sabde donde'
                },
              ]),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...content,
      ],
    );
  }

  Widget _buildCarouselSlider(List<Map<String, String>> images) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                _showDescriptionDialog(
                    context, image['description'] ?? 'Sin descripción');
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(image['image'] ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Future<void> _showDescriptionDialog(
      BuildContext context, String description) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Descripción'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TurismoScreen(),
  ));
}
