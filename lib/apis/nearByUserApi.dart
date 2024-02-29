import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/usersModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<Users>> fetchNearJSONData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? city = prefs.getString('city');
  print('sfgsdefe $city');

  var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
      body: {
        'keyword': city,
        'type': 'profile',
      "limit": '3',
      "offset": '0',
      });

  print('sdfsdf ${jsonResponse}');
  if (jsonResponse.statusCode == 200) {
    print('sdfsdf ${jsonResponse.body}');
    final jsonItems = json.decode(jsonResponse.body);

    List<Users> usersList = jsonItems['data']
        .map<Users>((json) {
      return Users.fromJson(json);
    }).toList();
    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}
