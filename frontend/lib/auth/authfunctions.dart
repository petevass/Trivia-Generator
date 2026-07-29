import 'package:frontend/auth/AuthenticationResponses.dart';
import'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import "dart:convert";


bool? isLoggedIn(){


  String? isLoggedIn = web.window.localStorage.getItem("logged-in");
  return isLoggedIn == 'true';
}

void setToken(String token) {


  web.window.localStorage.setItem("trivia-token", token);
  web.window.localStorage.setItem("logged-in", 'true');

}

String? getToken(){
  return web.window.localStorage.getItem("trivia-token");
}

void logOut()  {

    web.window.localStorage.setItem("logged-in", 'false');
    web.window.localStorage.removeItem("trivia-token");
}

Future<int> Authenticate(String username, String password) async{

  final resp = await http.post(

    Uri.parse("https://stardance-hosting.tail5b0cb9.ts.net/api/auth/authenticate"),
    headers: {
      "Content-Type": "application/json"
    },

    body: jsonEncode({
      "username": username,
      "password": password
    })

  );

    if(resp.statusCode == 200) {
      AuthenticateResponse authResp =  await AuthenticateResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
      setToken(authResp.token);
    }

    return resp.statusCode;
}

Future<int> Register(String username, String password) async{

  final resp = await http.post(

      Uri.parse("https://stardance-hosting.tail5b0cb9.ts.net/api/auth/register"),
      headers: {
        "Content-Type": "application/json"
      },

      body: jsonEncode({
        "username": username,
        "password": password
      })
  );


  if(resp.statusCode == 200) {
    AuthenticateResponse authResp =  await AuthenticateResponse.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
    setToken(authResp.token);

  }
  return resp.statusCode;
}