import 'dart:convert';
import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/profileModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<profile>> fetchProfileJSONData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? link = prefs.getString('link');

  var jsonResponse = await http.post(Uri.parse(apiURL + "index"),
      body: {
        'q': link
      }
      );

  print('sdfsdf ${jsonResponse}');
  if (jsonResponse.statusCode == 200) {
    print('sdfsdf ${jsonResponse.body}');
    final jsonItems = json.decode(jsonResponse.body);

    List<profile> usersList = jsonItems['data']
        .map<profile>((json) {
      return profile.fromJson(json);
    }).toList();
    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}



