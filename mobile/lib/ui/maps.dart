import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";
import 'package:http/http.dart' as http;
import 'package:pfe/ui/details.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Position _position;
  List<Marker> markers = [];

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _position = await Geolocator.getCurrentPosition();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        forceAndroidLocationManager: true,
        timeLimit: Duration(seconds: 10));
    print(position);
    setState(() {
      _position = position;
    });
  }

  @override
  void initState() {
    getAllMarkers();
    getLocation();
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(35.825603, 10.608395),
        zoom: 12.0,
      ),
      nonRotatedLayers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
    );
  }

  Future<void> getAllMarkers() async {
    String url = "http://10.0.2.2:3000/api/stadium/all";
    var response = await http.get(Uri.parse(url));
    var stadiums = json.decode(response.body);
    stadiums['data'].map((dynamic stadium) {
      print(stadium['_id']);
      markers.add(Marker(
          width: 30.0,
          height: 30.0,
          point:
              LatLng(stadium['positions']['lat'], stadium['positions']['lng']),
          builder: (ctx) => Container(
                child: GestureDetector(
                  child: Image.asset("assets/icons/marker.png"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Details(
                                idStadium: stadium['_id'],
                              )),
                    );
                  },
                ),
              )));
    }).toList();
  }
}
