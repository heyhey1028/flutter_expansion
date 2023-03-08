import 'dart:async';

import 'package:almost_zenly/screens/map_screen/components/sign_in_button.dart';
import 'package:almost_zenly/screens/map_screen/components/sign_out_button.dart';
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
  // ------------  GoogleMap  ------------
  final Completer<GoogleMapController> mapCompleter = Completer();
  late GoogleMapController mapController;
  late StreamSubscription<Position> positionStream;
  Set<Marker> markers = {};

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 16.0,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high, //正確性:highはAndroid(0-100m),iOS(10m)
    distanceFilter: 0,
  );

  // ------------  Auth  ------------
  late StreamSubscription<User?> authUserStream;

  // ------------  State changes  ------------
  bool isLoading = false;
  bool isLoggedIn = false;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void setIsLoggedIn(bool value) {
    setState(() {
      isLoggedIn = value;
    });
  }

  @override
  void initState() {
    Future(() async {
      mapController = await mapCompleter.future;
      await _requestPermission();
      await _moveToCurrentLocation();
      _watchCurrentLocation();
    });

    // 現在ログイン済みか確認
    _checkLoginState();
    // ログイン状態の変化を監視
    _watchLoginState();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    positionStream.cancel();
    authUserStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            mapCompleter.complete(controller);
          },
          myLocationButtonEnabled: false,
          markers: markers,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !isLoggedIn
            ? const SignInButton()
            : SignOutButton(
                onPressed: _signOut,
                isLoading: isLoading,
              ));
  }

  // ------------  Methods for GoogleMap  ------------

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
      // 現在地にカメラを移動
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
    });
  }

  // ------------  Methods for Auth  ------------
  void _checkLoginState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setIsLoggedIn(true);
    }
  }

  void _watchLoginState() {
    setState(() {
      authUserStream =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          setIsLoggedIn(false);
        } else {
          setIsLoggedIn(true);
        }
      });
    });
  }

  Future<void> _signOut() async {
    try {
      setIsLoading(true);
      await Future.delayed(const Duration(seconds: 1), () {});
      await FirebaseAuth.instance.signOut();
    } finally {
      setIsLoading(false);
    }
  }
}
