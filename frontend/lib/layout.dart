import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/auth/authfunctions.dart';

class Layout extends StatelessWidget{
  const Layout({super.key, required this.activeIndex, required this.body, });

  final Widget body;
  final int activeIndex;

  List<Widget> getTabs(){

    if(isLoggedIn() == true){

      return [
        Tab(icon: Icon(Icons.home), text: "Home"),
        Tab(icon: Icon(Icons.leaderboard), text:"Leaderboard"),
        Tab(icon: Icon(Icons.play_circle_outlined), text:"Play"),
        Tab(icon: Icon(Icons.person), text:"Profile"),
        Tab(icon: Icon(Icons.logout), text:"Log Out"),
      ];

    }

  return  [Tab(icon: Icon(Icons.home), text: "Home"),
          Tab(icon: Icon(Icons.login), text: "Log In"),
          Tab(icon: Icon(Icons.app_registration), text:"Register")
          ];


}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: activeIndex,
      length: isLoggedIn() == true ? 5 : 3,
      child: Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Trivia Generator", style: TextStyle(color: Colors.white)),
            SizedBox(
              width: isLoggedIn() == true ? 570 : 300,
            child: TabBar(
              labelColor:Colors.black,
              unselectedLabelColor: Colors.white,
                tabs: getTabs(),

                onTap:(index)=>{
                  if (isLoggedIn() == true) {
                    if (index == 0) {
                      Navigator.pushReplacementNamed(context, "/")
                     } else if (index == 1) {
                      Navigator.pushReplacementNamed(context, "/leaderboard")
                    } else if (index == 2) {
                    Navigator.pushReplacementNamed(context, "/play")
                    } else if (index == 3) {
                    Navigator.pushReplacementNamed(context, "/profile")
                    } else if (index == 4) {
                      Navigator.pushReplacementNamed(context, "/logout")
                    }
        } else {
    if (index == 0) {
    Navigator.pushReplacementNamed(context, "/")
    } else if (index == 1) {
    Navigator.pushReplacementNamed(context, "/login")

    } else if (index == 2) {
    Navigator.pushReplacementNamed(context, "/register")
    }
    }


                  }

                  ),
            )

          ],
        ),

      ),


      body: body,
          )
    );
  }


}