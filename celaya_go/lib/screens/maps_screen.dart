import 'dart:async';
import 'package:celaya_go/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:celaya_go/screens/turismo_screen.dart';
import 'package:celaya_go/models/markers_model.dart';

void main() => runApp(MaterialApp(
      home: MapSample(),
    ));

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    MapScreen(),
    TurismoScreen(),
    PlaceholderWidget(Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_on_sharp),
            label: 'Turismo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_sharp),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LocationData _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isMarkerSelected = false;
  MarkerModel? _selectedMarker;

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

  //Carga las ubicaciones guardadas en la base de datos
//   Future<void> _loadMarkers() async {
//   List<MarkerModel> markers = await _databaseHelper.getMarkers();
//   setState(() {
//     _markers = markers.map((marker) {
//       return Marker(
//         markerId: MarkerId(marker.id.toString()),
//         position: LatLng(double.parse(marker.latitude!),
//             double.parse(marker.longitude!)),
//         infoWindow: InfoWindow(title: marker.title),
//       );
//     }).toSet();
//   });
// }
  Future<void> _loadMarkers() async {
    List<MarkerModel> markers = await _databaseHelper.getMarkers();
    setState(() {
      _markers = markers.map((marker) {
        return Marker(
          markerId: MarkerId(marker.id.toString()),
          position: LatLng(
              double.parse(marker.latitude!), double.parse(marker.longitude!)),
          infoWindow: InfoWindow(title: marker.title),
          onTap: () {
            setState(() {
              _selectedMarker = marker;
              _isMarkerSelected = true;
            });
          },
        );
      }).toSet();
    });
  }

  //Metodo con el que se agrega una ubicacion
  Future<void> _addMarker(LatLng position, String title) async {
    Marker newMarker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(title: title),
    );

    setState(() {
      _markers.add(newMarker);
    });

    // Inserta el nuevo marcador en la base de datos
    await _databaseHelper.INSERT(
        'markers',
        MarkerModel(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          title: title,
        ));

    // Carga y muestra los marcadores actualizados desde la base de datos
    List<MarkerModel> markerModels = await _databaseHelper.getMarkers();

    _showSavedMarkers(markerModels);
  }

  //muestra los datos de la tabla (es solo para revicion no se debe moestrar al usuario)
  Future<void> _showSavedMarkers(List<MarkerModel> markers) async {
    String markerInfo = '';
    markers.forEach((marker) {
      markerInfo +=
          'ID: ${marker.id}, Title: ${marker.title}, Latitude: ${marker.latitude}, Longitude: ${marker.longitude}\n';
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubicaciones guardadas'),
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

  void _deleteMarker(MarkerModel marker) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar ubicación'),
          content: Text('¿Estás seguro de que deseas eliminar esta ubicación?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Elimina el marcador de la base de datos
                await _databaseHelper.deleteMarker(marker.id!);

                // Actualiza la lista de marcadores y vuelve a cargarlos
                _loadMarkers();

                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showMarkerOptions(MarkerModel marker) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
              onTap: () {
                Navigator.pop(context); // Cierra el BottomSheet
                _editMarker(marker);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Detalles'),
              onTap: () {
                Navigator.pop(context); // Cierra el BottomSheet
                _showMarkerDetails(marker);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar'),
              onTap: () {
                Navigator.pop(context); // Cierra el BottomSheet
                _deleteMarker(marker);
              },
            ),
          ],
        );
      },
    );
  }

// Función para editar un marcador
  void _editMarker(MarkerModel marker) async {
    TextEditingController titleController = TextEditingController();
    titleController.text = marker.title ?? '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar ubicación'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Nuevo nombre'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                String newTitle = titleController.text.trim();
                if (newTitle.isNotEmpty) {
                  // Actualiza el marcador en la base de datos
                  marker.title = newTitle;
                  await _databaseHelper.updateMarker(marker.toMap());

                  // Actualiza la lista de marcadores y vuelve a cargarlos
                  _loadMarkers();

                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Función para mostrar detalles de un marcador
  void _showMarkerDetails(MarkerModel marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del marcador'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${marker.id}'),
              Text('Título: ${marker.title}'),
              Text('Latitud: ${marker.latitude}'),
              Text('Longitud: ${marker.longitude}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  //boton que te mandara a una ubicacion (aun falta modificar)
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
      appBar: AppBar(
        title: Text('Celaya Go'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.none,
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
                      //_isMarkerSelected = false;
                      //setState(() {
                      //  _selectedMarker = null;
                      //});
                      _showMarkerDialog(position);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isMarkerSelected) {
                      _showMarkerOptions(_selectedMarker!);
                    }
                  },
                  child: Text('Mostrar opciones'),
                ),
                // if (_isMarkerSelected)
                //   ElevatedButton(
                //     onPressed: () {
                //       // Acción de editar
                //       // Puedes implementar la acción de editar aquí
                //       _editMarker(_selectedMarker!);
                //     },
                //     child: Text('Editar'),
                //   ),
                // if (_isMarkerSelected)
                //   ElevatedButton(
                //     onPressed: () {
                //       // Acción de detalles
                //       // Puedes implementar la acción de detalles aquí
                //       _showMarkerDetails(_selectedMarker!);
                //     },
                //     child: Text('Detalles'),
                //   ),
                // if (_isMarkerSelected)
                //   ElevatedButton(
                //     onPressed: () {
                //       // Acción de eliminar
                //       // Puedes implementar la acción de eliminar aquí
                //       _deleteMarker(_selectedMarker!);
                //     },
                //     child: Text('Eliminar'),
                //   ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  //Cuando se toque la pantalla mostrara el siguiente recuadro para agregar el nombre del marcador(ubicacion)
  Future<void> _showMarkerDialog(LatLng position) async {
    TextEditingController titleController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingrese el nombre de la ubicacion'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Nombre'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
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

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          'Placeholder',
          style: TextStyle(fontSize: 22.0),
        ),
      ),
    );
  }
}
