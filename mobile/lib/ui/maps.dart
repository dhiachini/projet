import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
  bool isLoading = true;
  Marker initMarker;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _position = await Geolocator.getCurrentPosition();
    Marker(point: LatLng(_position.latitude, _position.altitude));
    return _position;
  }

  void getLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(Duration(seconds: 10));
      print(position);
      setState(() {
        _position = position;
      });
    }
  }

  @override
  void initState() {
    //getAllMarkers();
    //getLocation();

    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FlutterMap(
              options: MapOptions(
                center: LatLng(_position.latitude, _position.longitude),
                zoom: 16.0,
              ),
              nonRotatedLayers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: markers,
                ),
              ],
            );
          } else {
            Center(child: CircularProgressIndicator());
          }
        });
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
