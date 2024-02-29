import 'dart:convert';

import 'package:findpro/models/searchModel.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/Constants.dart';

Future<List<Search>> fetchSearchJSONData(type) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('loginId');
  String? keyword = prefs.getString('keyword');

  print('sdfsjhhdf ${userId}');
  print('sdfsjhhdf ${keyword}');
  var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
      body:{
        'lister_id': (userId != null)?userId: null,
        'keyword': keyword,
        "type": type,
        "limit": '10',
        "offset": '0'
      });

  print('sdfsfgfdf ${jsonResponse.body}');
  if (jsonResponse.statusCode == 200) {
    final jsonItems = jsonDecode(jsonResponse.body);
    // final jsonItems = json.decode(json.encode(jsonResponse.body));
     print('sdfesdef $jsonItems');

    List<Search> usersList = jsonItems['data']
        .map<Search>((json) {
      return Search.fromJson(json);
    }).toList();
    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}


// Future<List<Users>> fetchSearchJSONData() async {
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? keyword = prefs.getString('keyword');
//
//   var jsonResponse = await http.get(Uri.parse(apiURL + "index"));
//
//   if (jsonResponse.statusCode == 200) {
//     final jsonItems = json.decode(jsonResponse.body);
//
//     List<Users> usersList = jsonItems['data'].map<Users>((json) {
//       return Users.fromJson(json);
//     }).toList();
//
//     return usersList;
//   } else {
//     throw Exception('Failed to load data from internet');
//   }
// }