import 'package:flutter/material.dart';
import 'package:frontend/Pages/AuthenticationPage.dart';
import 'package:frontend/Pages/Leaderboard.dart';
import 'package:frontend/auth/authfunctions.dart';
import 'package:frontend/layout.dart';
import 'package:web/web.dart' as web;
import 'Pages/Index.dart';
import 'Pages/Profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [RouteObserver()],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.lightBlueAccent),
      ),

      initialRoute: "/",
      routes:{
        "/" : (context)=>Layout(activeIndex: 0, body:const Index()),
        "/login": (context) => Layout(activeIndex: 1, body: AuthenticationPage(page: AuthPage.LOGIN)),
        "/register":(context) => Layout(activeIndex: 2, body: AuthenticationPage(page: AuthPage.REGISTER)),
        "/leaderboard":(context){
          if(isLoggedIn() == false){
            Navigator.pushReplacementNamed(context, "/login");
            return Layout(activeIndex: 1, body: AuthenticationPage(page: AuthPage.LOGIN));
          }
          return Layout(activeIndex: 1, body: Leaderboard());
        },
        "/profile":(context){
          if(isLoggedIn() == false){
            Navigator.pushReplacementNamed(context, "/login");
            return Layout(activeIndex: 1, body: AuthenticationPage(page: AuthPage.LOGIN));
          }
          return Layout(activeIndex: 3, body: Profile());
        }
      },
    );
  }
}

class RouteObserver extends NavigatorObserver{

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    handleRequest(route.settings.name);


  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if(newRoute != null){
      handleRequest(newRoute.settings.name);
    }

  }

  void handleRequest(String? route){
    if((route == "/login" || route == "/register")&& isLoggedIn() == true){
      web.window.location.href = "/";
    }

  }

}


