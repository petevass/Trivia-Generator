import 'package:frontend/Pages/AuthenticationPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web/web.dart' hide Text, Navigator;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Text, Navigator;

import '../API/fetch.dart';
import '../API/fetch_responses.dart';
import '../layout.dart';

class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<User>(
    future: new fetch().fetchUserInfo() ,
    builder:(context, snapshot) {

      if(snapshot.connectionState == ConnectionState.waiting){
        return const Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        );
      }

      if(snapshot.hasError){
        return Padding(
            padding: const EdgeInsets.all(20),
            child: Text("Failed to load: ${snapshot.error}")
        );
      }
      User u = snapshot.data ?? new User(name: "", totalCorrect: 0, totalAnswered: 0);
      if(u.name == ""){
        Navigator.pushReplacementNamed(context, "/login");
        return Layout(activeIndex: 1, body: AuthenticationPage(page: AuthPage.LOGIN));
      }
      return SingleChildScrollView(

        scrollDirection: Axis.vertical,
        child: Container(

          decoration: BoxDecoration(
            color: Colors.blue
          ),
          child: Center(

          child: Column(
            children: [

              SizedBox(height: 150),
              Text("${u.name.toUpperCase()}'s Stats",
                style: GoogleFonts.novaSquare(fontSize: 60, color: Colors.white),
              ),
              SizedBox(height:40),
              Wrap(
                spacing: 50,

                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Text("${u.totalAnswered}",
                          style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white),
                        ),
                        SizedBox(height: 25,),
                        Text("Answered",
                          style: GoogleFonts.novaSquare(fontSize: 25, color: Colors.white),
                        )
                  ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    height: 150,
                    width: 150,
                    child: Column(
                        children: [
                          Text("${u.totalCorrect}",
                            style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white),
                          ),
                          SizedBox(height: 25,),
                          Text("Correct",
                            style: GoogleFonts.novaSquare(fontSize: 25, color: Colors.white),
                          )
                        ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    height: 150,
                    width: 150,
                    child: Column(
                        children: [
                          Text("${u.totalAnswered - u.totalCorrect}",
                            style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white),
                          ),
                          SizedBox(height: 25,),
                          Text("Wrong",
                            style: GoogleFonts.novaSquare(fontSize: 25, color: Colors.white),
                          )
                        ]
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    height: 150,
                    width: 150,
                    child: Column(
                        children: [
                          Text("${
                          u.totalAnswered > 0 ?
                              u.totalCorrect/u.totalAnswered *100
                          :
                              "0%"
                          }",
                            style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white),
                          ),
                          SizedBox(height: 25,),
                          Text("Percentage",
                            style: GoogleFonts.novaSquare(fontSize: 25, color: Colors.white),
                          )
                        ]
                    ),
                  )
                ],
              ),
              SizedBox(height:100),
              Wrap(

                spacing: 35,
                children: [
                  SizedBox(
                    width: 170,
                    height: 75,
                    child: ElevatedButton.icon(
                      onPressed: ()=>Navigator.pushReplacementNamed(context, "/leaderboard"),
                      icon: Icon(Icons.leaderboard),
                      label: Text("Leaderboard"),
                    ),
                  ),

                  SizedBox(
                    width: 170,
                    height: 75,
                    child: ElevatedButton.icon(
                      onPressed: ()=>Navigator.pushReplacementNamed(context, "/play"),
                      icon: Icon(Icons.play_circle_outlined),
                      label: Text("Play"),
                    ),
                  )

                ],
              ),
              SizedBox(height: 200,)
            ],
          ),
        ),
        )
      );
    }
    );
  }
}