import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";
import 'package:http/http.dart' as http;
import 'package:pfe/ui/screens/details.dart';
import 'package:geolocator/geolocator.dart';

class Maps extends StatefulWidget {
  const Maps({Key key, AnimationController animationController});
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Position _position;
  List<Marker> markers = [];

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

    return await Geolocator.getCurrentPosition();
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

  calculateDistance() {
    return Geolocator.distanceBetween(_position.altitude, _position.longitude,
        _position.altitude + 0.026578, _position.longitude + 0.654894);
  }

  @override
  void initState() {
    //getAllMarkers();
    //getLocation();

    _determinePosition();

    print('YAAAAAAAAAAAAAAAAAAAAAAA}');
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
                center: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                zoom: 16.0,
              ),
              nonRotatedLayers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: [
                  Marker(
                      width: 30.0,
                      height: 30.0,
                      point: LatLng(
                          snapshot.data.latitude, snapshot.data.longitude),
                      builder: (ctx) => Container(
                            child: GestureDetector(
                              child: Image.asset("assets/icons/marker.png"),
                            ),
                          )),
                ]),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> getAllMarkers() async {
    String url = "http://10.0.2.2:3000/api/stadium/all";
    var response = await http.get(Uri.parse(url));
    var stadiums = json.decode(response.body);
    stadiums['data'].map((dynamic stadium) {
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
