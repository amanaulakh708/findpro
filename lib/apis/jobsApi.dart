import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/jobsModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


  Future<List<Jobs>> fetchJobs(limit, offset) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('loginId');


  print('sdfsdf ${userId}');
  var jsonResponse = await http.post(Uri.parse(apiURL + "listing"),
      body: {
        'lister_id': (userId != null)?userId: '0',
        "type": 'jobs',
        "limit": limit.toString(),
        "offset": offset.toString(),
       });

  print('sdfsdf ${jsonResponse}');
  print('sdflklksdf ${limit}');


  if (jsonResponse.statusCode == 200){
    final  jsonItems = json.decode(jsonResponse.body);
    print('sdflkyukuklksdf ${jsonItems}');
    List<Jobs> usersList = jsonItems['data'].map<Jobs>((json) {
      return Jobs.fromJson(json);
    }).toList();
    return usersList;

  } else {
    throw Exception('Failed to load data from internet');
  }

}
