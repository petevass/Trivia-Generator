import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frontend/API/fetch_responses.dart';
import 'package:frontend/auth/authfunctions.dart';
import 'package:http/http.dart'as http;

class fetch{

  Future<http.Response> _get(String url, Map<String, String> headers)async{
    final resp = await http.get(Uri.parse(url),headers: headers);
    return resp;

  }

  Future<http.Response> _post(String url, Map<String, String> headers, Map<String, dynamic> body)async{
    final resp = await http.post(Uri.parse(url), headers: headers, body: body);
    return resp;
  }

  Future<List<TableRow>> fetchTotalLeaderboard()async{
    String? token = getToken();
    final resp = await _get("https://stardance-hosting.tail5b0cb9.ts.net/api/leaderboard/total", {
     "Authorization": "Bearer $token"
    });

    LeaderboardResponse responses = await new LeaderboardResponse.fromJson(jsonDecode(resp.body));

    return responses.rows;
  }

  Future<List<TableRow>> fetchCorrectLeaderboard()async{
    String? token = getToken();
    final resp = await _get("https://stardance-hosting.tail5b0cb9.ts.net/api/leaderboard/correct", {
      "Authorization": "Bearer $token"
    });

    LeaderboardResponse responses = await new LeaderboardResponse.fromJson(jsonDecode(resp.body));

    return responses.rows;
  }

  Future<User> fetchUserInfo()async{
    String? token = getToken();
    final resp = await _get("https://stardance-hosting.tail5b0cb9.ts.net/api/user/me",{
      "Authorization": "Bearer $token"
    });

    User u= await new User.fromJson(jsonDecode(resp.body));

    return u;
  }

}