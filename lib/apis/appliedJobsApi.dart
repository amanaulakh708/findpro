import 'dart:convert';

import 'package:findpro/global/Constants.dart';
import 'package:findpro/models/appliedJobsModel.dart';
import 'package:findpro/models/jobsModel.dart';
import 'package:findpro/models/usersModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<List<AplliedJobs>> fetchAppliedJobs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('loginId');

  print('sdfsdf ${userId}');
  var jsonResponse = await http.post(Uri.parse(apiURL + "applied_jobs"),
      body: {
        'lister_id': userId,
        "limit": '10',
        "offset": '0'
      });

  if (jsonResponse.statusCode == 200) {
    // print('sdfjyysdf ${jsonResponse.body}');
    final jsonItems = json.decode(jsonResponse.body);

    List<AplliedJobs> usersList = jsonItems['data']
        .map<AplliedJobs>((json){
      return AplliedJobs.fromJson(json);
    }).toList();
    print('jkjjkjnlnk $usersList');
    return usersList;
  } else {
    throw Exception('Failed to load data from internet');
  }
}