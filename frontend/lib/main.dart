import 'package:flutter/material.dart';
import 'package:frontend/Pages/AuthenticationPage.dart';
import 'package:frontend/Pages/Leaderboard.dart';
import 'package:frontend/Pages/Play.dart';
import 'package:frontend/auth/authfunctions.dart';
import 'package:frontend/layout.dart';
import 'Pages/Index.dart';
import 'Pages/Profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [AppRouteObserver()],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Layout(activeIndex: 0, body: const Index()),
        "/login": (context) => Layout(
          activeIndex: 1,
          body: AuthenticationPage(page: AuthPage.LOGIN),
        ),
        "/register": (context) => Layout(
          activeIndex: 2,
          body: AuthenticationPage(page: AuthPage.REGISTER),
        ),
        "/leaderboard": (context) {
          if (true != isLoggedIn()) {
            return Layout(
              activeIndex: 1,
              body: AuthenticationPage(page: AuthPage.LOGIN),
            );
          }
          return Layout(activeIndex: 1, body: Leaderboard());
        },
        "/profile": (context) {
          if (isLoggedIn() != true) {
            return Layout(
              activeIndex: 1,
              body: AuthenticationPage(page: AuthPage.LOGIN),
            );
          }
          return Layout(activeIndex: 3, body: Profile());
        },
        "/play": (context) {
          if (isLoggedIn() == false) {
            return Layout(
              activeIndex: 1,
              body: AuthenticationPage(page: AuthPage.LOGIN),
            );
          }
          return Layout(activeIndex: 2, body: PlayPage());
        },
      },
    );
  }
}

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _handleRequest(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _handleRequest(newRoute.settings.name);
    }
  }

  void _handleRequest(String? routeName) {
    if ((routeName == "/login" || routeName == "/register") && isLoggedIn() == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigator?.pushReplacementNamed("/");
      });
    }
  }
}