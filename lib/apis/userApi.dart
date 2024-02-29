import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:http/http.dart' as http;


Future<List<Users>> fetchJSONData() async {
  print('kukjkj');
  // var jsonResponse = await http.get(Uri.parse(apiURL +'index'));

  var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
      body: {
        "type": 'profile',
        "limit": '10',
        "offset": '0'
      });

print('sdfdalklsf $jsonResponse');
  if (jsonResponse.statusCode == 200) {
    final jsonItems = json.decode(jsonResponse.body);

    print('sdfdalklsf $jsonItems');

    List<Users> usersList = jsonItems['data'].map<Users>((json) {
      return Users.fromJson(json);
    }).toList();

    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}