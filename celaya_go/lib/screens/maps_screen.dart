// import 'dart:async';
// import 'package:celaya_go/database/database_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   late LocationData _currentLocation;
//   bool _isLoading = true;
//   Set<Marker> _markers = {};
//   DatabaseHelper _databaseHelper = DatabaseHelper();

//   @override
//   void initState() {
//     super.initState();
//     _initLocation();
//     _loadMarkers();
//   }

//   Future<void> _initLocation() async {
//     try {
//       var location = Location();
//       location.onLocationChanged.listen((LocationData currentLocation) {
//         if (mounted) {
//           setState(() {
//             _currentLocation = currentLocation;
//             _isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print("Error initializing location: $e");
//     }
//   }

//   Future<void> _loadMarkers() async {
//     List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();
//     setState(() {
//       _markers = markers.map((marker) {
//         return Marker(
//           markerId: MarkerId(marker['id'].toString()),
//           position: LatLng(marker['latitude'], marker['longitude']),
//           infoWindow: InfoWindow(title: marker['title']),
//         );
//       }).toSet();
//     });
//   }

//   Future<void> _addMarker(LatLng position, String title) async {
//   final MarkerId markerId = MarkerId(position.toString());

//   // Extraer los valores de la posición
//   double latitude = position.latitude;
//   double longitude = position.longitude;

//   final Marker marker = Marker(
//     markerId: markerId,
//     position: position,
//     infoWindow: InfoWindow(title: title),
//   );

//   setState(() {
//     _markers.add(marker);
//   });

//   // Guardar el marcador en la base de datos con valores extraídos
//   await _databaseHelper.insertMarker({
//     'id': markerId.value,
//     'latitude': latitude,
//     'longitude': longitude,
//     'title': title,
//   });

//   // Mostrar los marcadores guardados en la base de datos
//   await _showSavedMarkers();
// }

//   Future<void> _showSavedMarkers() async {
//   List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();

//   // Formatear los datos de los marcadores para mostrarlos en un mensaje
//   String markerInfo = 'Markers saved in the database:\n';
//   markers.forEach((marker) {
//     markerInfo +=
//         'ID: ${marker['id']}, Title: ${marker['title']}, Latitude: ${marker['latitude']}, Longitude: ${marker['longitude']}\n';
//   });

//   // Mostrar un mensaje con la información de los marcadores
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Saved Markers'),
//         content: Text(markerInfo),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }


//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             _currentLocation.latitude!,
//             _currentLocation.longitude!,
//           ),
//           zoom: 14.0,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   _currentLocation.latitude!,
//                   _currentLocation.longitude!,
//                 ),
//                 zoom: 14.0,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               markers: _markers,
//               onTap: (LatLng position) {
//                 _showMarkerDialog(position);
//               },
//             ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _showMarkerDialog(LatLng position) async {
//     TextEditingController titleController = TextEditingController();

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Marker Title'),
//           content: TextField(
//             controller: titleController,
//             decoration: InputDecoration(hintText: 'Title'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String title = titleController.text.trim();
//                 if (title.isNotEmpty) {
//                   _addMarker(position, title);
//                 }
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LocationData _currentLocation;
  bool _isLoading = true;

  final String apiKey = 'AIzaSyCuebpvNCyLRtq7HUpoxux29SKEdzSkQZY'; // Reemplaza con tu propia clave

  // Lista para almacenar lugares turísticos
  List<Map<String, dynamic>> touristPlaces = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _fetchTouristPlaces();
  }

  Future<void> _initLocation() async {
    try {
      var location = Location();
      location.onLocationChanged.listen((LocationData currentLocation) {
        if (mounted) {
          setState(() {
            _currentLocation = currentLocation;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  Future<void> _fetchTouristPlaces() async {
    try {
      // Puedes ajustar el radio y otros parámetros según tus necesidades
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation.latitude},${_currentLocation.longitude}&radius=5000&type=tourist_attraction&key=$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          setState(() {
            touristPlaces = List<Map<String, dynamic>>.from(data['results']);
          });
        }
      } else {
        print('Error fetching tourist places: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching tourist places: $e");
    }
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    // Marcador para la ubicación actual del usuario
    markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        infoWindow: InfoWindow(title: 'Tu ubicación actual'),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    // Marcadores para lugares turísticos
    for (var place in touristPlaces) {
      final location = place['geometry']['location'];
      markers.add(
        Marker(
          markerId: MarkerId(place['place_id']),
          position: LatLng(location['lat'], location['lng']),
          infoWindow: InfoWindow(title: place['name']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation.latitude!,
                  _currentLocation.longitude!,
                ),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _createMarkers(),
            ),
    );
  }

}*/


/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LocationData _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      var location = Location();
      location.onLocationChanged.listen((LocationData currentLocation) {
        if (mounted) {
          setState(() {
            _currentLocation = currentLocation;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation.latitude!,
                  _currentLocation.longitude!,
                ),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation.latitude!,
            _currentLocation.longitude!,
          ),
          zoom: 14.0,
        ),
      ),
    );
  }
}
*/



//aqui va el codigo con foto:


// import 'dart:async';
// import 'dart:io';
// import 'package:celaya_go/database/database_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:image_picker/image_picker.dart';

// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);

//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   late LocationData _currentLocation;
//   bool _isLoading = true;
//   Set<Marker> _markers = {};
//   DatabaseHelper _databaseHelper = DatabaseHelper();
//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     _initLocation();
//     _loadMarkers();
//   }

//   Future<void> _initLocation() async {
//     try {
//       var location = Location();
//       location.onLocationChanged.listen((LocationData currentLocation) {
//         if (mounted) {
//           setState(() {
//             _currentLocation = currentLocation;
//             _isLoading = false;
//           });
//         }
//       });
//     } catch (e) {
//       print("Error initializing location: $e");
//     }
//   }

//   Future<void> _loadMarkers() async {
//     List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();
//     setState(() {
//       _markers = markers.map((marker) {
//         return Marker(
//           markerId: MarkerId(marker['id'].toString()),
//           position: LatLng(marker['latitude'], marker['longitude']),
//           infoWindow: InfoWindow(title: marker['title']),
//         );
//       }).toSet();
//     });
//   }

//   Future<void> _showMarkerDialog(LatLng position) async {
//     TextEditingController titleController = TextEditingController();
//     TextEditingController typeController = TextEditingController();
//     TextEditingController descriptionController = TextEditingController();

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter Marker Information'),
//           content: Column(
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(hintText: 'Title'),
//               ),
//               TextField(
//                 controller: typeController,
//                 decoration: InputDecoration(hintText: 'Type (Green or Red)'),
//               ),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(hintText: 'Description'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final picker = ImagePicker();
//                   final pickedImage =
//                       await picker.pickImage(source: ImageSource.gallery);

//                   if (pickedImage != null) {
//                     setState(() {
//                       _selectedImage = File(pickedImage.path);
//                     });
//                   }
//                 },
//                 child: Text('Select Image'),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 String title = titleController.text.trim();
//                 String type = typeController.text.trim();
//                 String description = descriptionController.text.trim();

//                 if (title.isNotEmpty) {
//                   _addMarker(position, title, type, description, _selectedImage);
//                 }

//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _addMarker(LatLng position, String title, String type,
//       String description, File? image) async {
//     final MarkerId markerId = MarkerId(position.toString());

//     // Extraer los valores de la posición
//     double latitude = position.latitude;
//     double longitude = position.longitude;

//     final Marker marker = Marker(
//       markerId: markerId,
//       position: position,
//       infoWindow: InfoWindow(title: title),
//     );

//     setState(() {
//       _markers.add(marker);
//     });

//     // Guardar el marcador en la base de datos con valores extraídos
//     await _databaseHelper.insertMarker({
//       'id': markerId.value,
//       'latitude': latitude,
//       'longitude': longitude,
//       'title': title,
//       'type': type,
//       'description': description,
//       'image_path': image?.path, // Almacenar la ruta de la imagen
//     });

//     // Mostrar los marcadores guardados en la base de datos
//     await _showSavedMarkers();
//   }

//   Future<void> _showSavedMarkers() async {
//     List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();

//     // Formatear los datos de los marcadores para mostrarlos en un mensaje
//     String markerInfo = 'Markers saved in the database:\n';
//     markers.forEach((marker) {
//       markerInfo +=
//           'ID: ${marker['id']}, Title: ${marker['title']}, Latitude: ${marker['latitude']}, Longitude: ${marker['longitude']}, Type: ${marker['type']}, Description: ${marker['description']}, Image: ${marker['image_path']}\n';
//     });

//     // Mostrar un mensaje con la información de los marcadores
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Saved Markers'),
//           content: Text(markerInfo),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             _currentLocation.latitude!,
//             _currentLocation.longitude!,
//           ),
//           zoom: 14.0,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(
//                   _currentLocation.latitude!,
//                   _currentLocation.longitude!,
//                 ),
//                 zoom: 14.0,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               markers: _markers,
//               onTap: (LatLng position) {
//                 _showMarkerDialog(position);
//               },
//             ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:celaya_go/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LocationData _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadMarkers();
  }

  Future<void> _initLocation() async {
    try {
      var location = Location();
      location.onLocationChanged.listen((LocationData currentLocation) {
        if (mounted) {
          setState(() {
            _currentLocation = currentLocation;
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      print("Error initializing location: $e");
    }
  }

  Future<void> _loadMarkers() async {
    List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();
    setState(() {
      _markers = markers.map((marker) {
        return Marker(
          markerId: MarkerId(marker['id'].toString()),
          position: LatLng(marker['latitude'], marker['longitude']),
          infoWindow: InfoWindow(title: marker['title']),
        );
      }).toSet();
    });
  }

  Future<void> _addMarker(LatLng position, String title) async {
  final MarkerId markerId = MarkerId(position.toString());

  // Extraer los valores de la posición
  double latitude = position.latitude;
  double longitude = position.longitude;

  final Marker marker = Marker(
    markerId: markerId,
    position: position,
    infoWindow: InfoWindow(title: title),
  );

  setState(() {
    _markers.add(marker);
  });

  // Guardar el marcador en la base de datos con valores extraídos
  await _databaseHelper.INSERT('markers', {
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'title': title,
  });

  // Mostrar los marcadores guardados en la base de datos
  await _showSavedMarkers();
}



  Future<void> _showSavedMarkers() async {
  List<Map<String, dynamic>> markers = await _databaseHelper.getMarkers();

  // Formatear los datos de los marcadores para mostrarlos en un mensaje
  String markerInfo = 'Markers saved in the database:\n';
  markers.forEach((marker) {
    markerInfo +=
        'ID: ${marker['id']}, Title: ${marker['title']}, Latitude: ${marker['latitude']}, Longitude: ${marker['longitude']}\n';
  });

  // Mostrar un mensaje con la información de los marcadores
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Saved Markers'),
        content: Text(markerInfo),
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


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation.latitude!,
            _currentLocation.longitude!,
          ),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation.latitude!,
                  _currentLocation.longitude!,
                ),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onTap: (LatLng position) {
                _showMarkerDialog(position);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _showMarkerDialog(LatLng position) async {
    TextEditingController titleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Marker Title'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text.trim();
                if (title.isNotEmpty) {
                  _addMarker(position, title);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}