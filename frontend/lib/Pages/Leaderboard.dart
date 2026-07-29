
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, size: 60,),
                  Text("Leaderboard")
                ],
              )

            ],
          ),
        ),
      )
    );

  }

}