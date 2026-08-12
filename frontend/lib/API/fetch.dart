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
    final resp = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
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

  Future<GetQuestion> getInitialQuestion(String category, String difficulty, String type, int amount) async{
      String? token = getToken();
      final SessionIdResp = await _post("https://stardance-hosting.tail5b0cb9.ts.net/api/session/start", {
        "Content-Type":"application/json",
        "Authorization":"Bearer $token"
      },
          {
            "category":category,
            "difficulty":difficulty,
            "type":type,
            "amount":amount
          }
      );

      String sessionId = jsonDecode(SessionIdResp.body)["sessionId"];
      setSessionId(sessionId);
      final questionResp = await _post("https://stardance-hosting.tail5b0cb9.ts.net/api/session/get_questions", {
        "Content-Type":"application/json",
        "Authorization":"Bearer $token"
      },
      {
       "sessionId":sessionId
      });

      GetQuestion gq = await new GetQuestion.fromJson(jsonDecode(questionResp.body));

      return gq;
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