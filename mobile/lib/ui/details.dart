import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:pfe/models/Stadium.dart';
import "package:latlong/latlong.dart";
import 'package:pfe/ui/verify.dart';

import 'catalogue.dart';

// ignore: must_be_immutable
class Details extends StatefulWidget {
  String idStadium;
  Details({Key key, this.idStadium}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Stadium stadium;
  double rate;
  Future<Stadium> getStadiumDetails(String id) async {
    String url = "http://10.0.2.2:3000/api/stadium/$id";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var js = json['stadium'];
    print(js['positions']);
    stadium = Stadium(
      description: js['description'],
      id: js['id'],
      name: js['name'],
      picPath: js['picPath'],
      rating: js['rating'],
      price: js['price'],
      positions:
          Positions(lat: js['positions']['lat'], lng: js['positions']['lng']),
    );

    return stadium;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stadium>(
        future: getStadiumDetails(this.widget.idStadium),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('Lat from snapshot : ${snapshot.data.positions.lat}');
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0)),
                      foregroundDecoration:
                          BoxDecoration(color: Colors.black26),
                      height: 400,
                      child: Image.network(stadium.picPath, fit: BoxFit.cover)),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 250),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '${stadium.name}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 16.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.tealAccent[700],
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Text(
                                "${stadium.rating}/5 reviews",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CatalogueScreen()));
                              },
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(32.0),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            // // // RatingBarIndicator(
                                            // // //   rating: stadium.rating,
                                            // // //   itemBuilder: (context, index) =>
                                            // // //       Icon(
                                            // // //     Icons.star,
                                            // // //     color: Colors.tealAccent[700],
                                            // // //   ),
                                            // //   itemCount: 5,
                                            // //   itemSize: 30.0,
                                            // //   direction: Axis.horizontal,
                                            // ),
                                          ],
                                        ),
                                        Text.rich(
                                          TextSpan(children: [
                                            WidgetSpan(
                                                child: Icon(
                                              Icons.location_on,
                                              size: 16.0,
                                              color: Colors.grey,
                                            )),
                                            TextSpan(text: "8 km to centrum")
                                          ]),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "DT ${stadium.price}",
                                        style: TextStyle(
                                            color: Colors.tealAccent[700],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      Text(
                                        "/per 1.5H",
                                        style: TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 30.0),
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  color: Colors.tealAccent[700],
                                  textColor: Colors.white,
                                  child: Text(
                                    "Book Now",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 32.0,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  },
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Text(
                                "Description".toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                '${stadium.description}',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: FlutterMap(
                            options: MapOptions(
                              center: LatLng(
                                  stadium.positions.lat, stadium.positions.lng),
                              zoom: 17.0,
                            ),
                            nonRotatedLayers: [
                              TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 70.0,
                                    height: 70.0,
                                    point: LatLng(stadium.positions.lat,
                                        stadium.positions.lng),
                                    builder: (ctx) => Container(
                                      child: Image.asset(
                                          'assets/images/marker.png'),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        "DETAIL",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: BottomNavigationBar(
                      backgroundColor: Colors.white54,
                      elevation: 0,
                      selectedItemColor: Colors.black,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.search), title: Text("Search")),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.favorite_border),
                            title: Text("Favorites")),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings),
                            title: Text("Settings")),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(child: Text("Error"));
          } else {
            return Container(
                color: Colors.white,
                child: Center(
                    child: CupertinoActivityIndicator(
                  radius: 20,
                )));
          }
        });
  }
}
