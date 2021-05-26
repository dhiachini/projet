import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pfe/models/Stadium.dart';

class Service {
  final String url = "http://10.0.2.2:3000/api/stadium/all";
  static Service _instance;
  factory Service() => _instance ??= new Service._();

  Service._();
  getStadiums() async {
    var response = await http.get(Uri.parse(url));
    var listGenerate = jsonDecode(response.body);
    return listGenerate["data"];
  }
}
