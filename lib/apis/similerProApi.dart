import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/usersModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



Future<List<Users>> fetchSimilarJSONData() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? category = prefs.getString('category');

  var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
      body: {
        // 'lister_id': (userId != null)?userId: null,
        'keyword': category,
        "type": 'profile',
        "limit": '10',
        "offset": '0'
      });

  // var jsonResponse = await http.get(Uri.parse(apiURL + 'index?keyword=' + category!));

  if (jsonResponse.statusCode == 200) {
    final jsonItems = json.decode(jsonResponse.body);
    print('jhjhbjb ${jsonItems}');

    List<Users> usersList = jsonItems['data'].map<Users>((json) {
      return Users.fromJson(json);
    }).toList();

    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}