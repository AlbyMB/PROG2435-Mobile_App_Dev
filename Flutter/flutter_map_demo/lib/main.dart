import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String output = "";
  double latitude = 43.47063;
  double longitude = -80.54138;
  List<Marker> markers = [
     Marker(
                    markerId: const MarkerId('UofW'),
                    position: LatLng(43.4680, -80.5373),
                    infoWindow: const InfoWindow(title: 'Current Location'),
                  ),
                  Marker(
                    markerId: const MarkerId('Conestoga College'),
                    position: LatLng(43.470639, -80.54138),
                    infoWindow: const InfoWindow(title: 'Current Location'),
                  ),
  ];


  late GoogleMapController mapController;

  Future<void> getLocation() async {
    // 1. check if the device has GPS enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == false) {
      setState(() {
        output = "GPS is not enabled";
      });
      return;
    }

    // 2. Display a popup that asks ther user for location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          output = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        output = "Location permission denied forever";
      });
      return;
    }

    // 4. Handle the case when the user allows the permission
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      // move the camera to the current location
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
          ),
        ),
      );
      output =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                getLocation();
              },
              child: const Text('Get Current Location'),
            ),
            Text("Device Location: "),
            Text("$output"),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: Set<Marker>.of(markers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
