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
                  'image': 'assets/lugar_turistico_2.jpg',
                  'description': 'Descripción del lugar 2'
                },
                {
                  'image': 'assets/lugar_turistico_3.jpg',
                  'description': 'Descripción del lugar 3'
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
                  'image': 'assets/restaurante_1.jpg',
                  'description': 'Descripción del restaurante 1'
                },
                {
                  'image': 'assets/restaurante_2.jpg',
                  'description': 'Descripción del restaurante 2'
                },
                {
                  'image': 'assets/restaurante_3.jpg',
                  'description': 'Descripción del restaurante 3'
                },
              ]),
            ]),
            _buildSection('Lugares no Seguros', [
              _buildCarouselSlider([
                {
                  'image': 'assets/lugar_no_seguro_1.jpg',
                  'description': 'Descripción del lugar no seguro 1'
                },
                {
                  'image': 'assets/lugar_no_seguro_2.jpg',
                  'description': 'Descripción del lugar no seguro 2'
                },
                {
                  'image': 'assets/lugar_no_seguro_3.jpg',
                  'description': 'Descripción del lugar no seguro 3'
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
