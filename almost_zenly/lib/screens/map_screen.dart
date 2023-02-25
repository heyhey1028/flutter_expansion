import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 16.0,
  );

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    // 位置情報の許可を求める
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    // 現在地を取得
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId("my_location"),
        position: LatLng(position.latitude, position.longitude),
        draggable: true,
        onDragEnd: (value) {
          // value is the new position
        },
      ));
    });
    // 現在地にカメラを移動
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: _onMapCreated,
        myLocationButtonEnabled: false,
        markers: markers,
      ),
    );
  }
}
