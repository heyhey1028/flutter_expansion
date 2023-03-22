import 'dart:async';

import 'package:almost_zenly/screens/map_screen/components/profile_button.dart';
import 'package:almost_zenly/screens/map_screen/components/sign_in_button.dart';
import 'package:almost_zenly/screens/profile_screen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late StreamSubscription<Position> positionStream;
  Set<Marker> markers = {};

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 16.0,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 20,
  );

  // ------------  Auth  ------------
  late StreamSubscription<User?> authUserStream;
  String currentUserId = '';
  bool isSignedIn = false;

  // ------------  State changes  ------------
  void setIsSignedIn(bool value) {
    setState(() {
      isSignedIn = value;
    });
  }

  void setCurrentUserId(String value) {
    setState(() {
      currentUserId = value;
    });
  }

  @override
  void initState() {
    // ログイン状態の変化を監視
    _watchSignInState();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    positionStream.cancel();
    // ログイン状態の監視を解放
    authUserStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) async {
          mapController = controller;
          await _requestPermission();
          await _moveToCurrentLocation();
          _watchCurrentLocation();
        },
        myLocationButtonEnabled: false,
        markers: markers,
      ),
      floatingActionButtonLocation: !isSignedIn
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endTop,
      floatingActionButton: !isSignedIn
          ? const SignInButton()
          : ProfileButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }),
    );
  }

  Future<void> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // 現在地を取得
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
        ));
      });

      // 現在地にカメラを移動
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    }
  }

  void _watchCurrentLocation() {
    // 現在地を監視
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) async {
      // マーカーの位置を更新
      setState(() {
        markers.removeWhere(
            (marker) => marker.markerId == const MarkerId('current_location'));

        markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
        ));
      });

      // Firestoreに現在地を更新
      await _updateUserLocationInFirestore(position);
      // 現在地にカメラを移動
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: await mapController.getZoomLevel(),
          ),
        ),
      );
    });
  }

  // ------------  Methods for Auth  ------------
  void _watchSignInState() {
    setState(() {
      authUserStream =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          setIsSignedIn(false);
          setCurrentUserId('');
        } else {
          setIsSignedIn(true);
          setCurrentUserId(user.uid);
        }
      });
    });
  }

  // ------------  Methods for Firestore  ------------

  Future<void> _updateUserLocationInFirestore(Position position) async {
    if (isSignedIn) {
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(currentUserId)
          .update({
        'location': GeoPoint(
          position.latitude,
          position.longitude,
        ),
      });
    }
  }
}
