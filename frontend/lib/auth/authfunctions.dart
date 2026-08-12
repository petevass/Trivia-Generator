import 'package:frontend/auth/AuthenticationResponses.dart';
import'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import "dart:convert";


bool? isLoggedIn(){


  String? isLoggedIn = web.window.sessionStorage.getItem("logged-in");
  return isLoggedIn == 'true';
}

void setToken(String token) {


  web.window.sessionStorage.setItem("trivia-token", token);
  web.window.sessionStorage.setItem("logged-in", 'true');

}

String? getToken(){
  return web.window.sessionStorage.getItem("trivia-token");
}

void logOut()  {

    web.window.sessionStorage.setItem("logged-in", 'false');
    web.window.sessionStorage.removeItem("trivia-token");
}


void setSessionId(String id){
  web.window.sessionStorage.setItem("session-id", id);
}

String? getSessionId(){
  return web.window.sessionStorage.getItem("session-id");
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