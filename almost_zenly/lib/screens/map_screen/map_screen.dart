import 'dart:async';

import 'package:almost_zenly/models/app_user.dart';
import 'package:almost_zenly/screens/map_screen/components/card_section.dart';
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
  late StreamSubscription usersStream;
  late Position currentUserPosition;

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 16.0,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  // ------------  Auth  ------------
  late StreamSubscription<User?> authUserStream;
  String currentUserId = '';

  // ------------  State changes  ------------
  bool isSignedIn = false;

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
    _watchUsers();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    positionStream.cancel();
    authUserStream.cancel();
    usersStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              await _requestPermission();
              await _moveToCurrentLocation();
              _watchCurrentLocation();
            },
            myLocationButtonEnabled: true,
            markers: markers,
          ),
          StreamBuilder(
            stream: getAppUserStream(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData && isSignedIn) {
                final users = snapshot.data!
                    .where((user) => user.id != currentUserId)
                    .where((user) => user.coordinate != null)
                    .toList();

                return CardSection(
                  onPageChanged: (index) {
                    //スワイプ後のページのお店を取得
                    late GeoPoint coordinate;
                    if (index == 0) {
                      coordinate = GeoPoint(
                        currentUserPosition.latitude,
                        currentUserPosition.longitude,
                      );
                    } else {
                      coordinate = users.elementAt(index - 1).coordinate!;
                    }
                    //スワイプ後のお店の座標までカメラを移動
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            coordinate.latitude,
                            coordinate.longitude,
                          ),
                          zoom: 16.0,
                        ),
                      ),
                    );
                  },
                  appUsers: users,
                );
              }
              return Container();
            },
          ),
        ],
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

  // ------------  Methods for Map  ------------
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
        currentUserPosition = position;

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
        currentUserPosition = position;

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
      // Firestoreに現在地を書き込む
      await _updateUserLocationInFirestore(position);

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
  void _watchSignInState() {
    setState(() {
      authUserStream =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          setIsSignedIn(false);
          markers.clear();
        } else {
          setIsSignedIn(true);
          setCurrentUserId(user.uid);
        }
      });
    });
  }

  // ------------  Methods for Firestore  ------------
  Stream<List<AppUser>> getAppUserStream() {
    return FirebaseFirestore.instance.collection('app_users').snapshots().map(
          (snp) => snp.docs
              .map((doc) => AppUser.fromDoc(doc.id, doc.data()))
              .toList(),
        );
  }

  void _watchUsers() {
    usersStream = getAppUserStream().listen((users) {
      final otherUsers =
          users.where((user) => user.id != currentUserId).toList();
      for (final user in otherUsers) {
        if (user.coordinate != null && isSignedIn) {
          final lat = user.coordinate!.latitude;
          final lng = user.coordinate!.longitude;
          setState(() {
            if (markers
                .where((m) => m.markerId == MarkerId(user.id!))
                .isNotEmpty) {
              markers.removeWhere(
                (marker) => marker.markerId == MarkerId(user.id!),
              );
            }
            markers.add(Marker(
              markerId: MarkerId(user.id!),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
            ));
          });
        }
      }
    });
  }

  // Firestoreのユーザーデータに現在地を更新する関数
  Future<void> _updateUserLocationInFirestore(Position position) async {
    if (isSignedIn) {
      await FirebaseFirestore.instance
          .collection('app_users')
          .doc(currentUserId)
          .update({
        'coordinate': GeoPoint(
          position.latitude,
          position.longitude,
        ),
      });
    }
  }
}
