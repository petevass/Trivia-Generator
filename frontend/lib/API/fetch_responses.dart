import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderboardEntries{
  final String username;
  final int totalAnswered;
  final int totalCorrect;
  const LeaderboardEntries({required this.username, required this.totalAnswered, required this.totalCorrect});

  factory LeaderboardEntries.fromJson(Map<String, dynamic> json){
    return LeaderboardEntries(
    username: json["username"],
    totalAnswered: json["totalAnswered"],
    totalCorrect: json["totalCorrect"]
    );
  }

}

class User{
  final String name;
  final double totalAnswered;
  final double totalCorrect;

  const User({required this.name,required this.totalAnswered, required this.totalCorrect});

  factory User.fromJson(Map<String, dynamic> json){

    return User(
      name: json["username"],
      totalAnswered: json["totalAnswered"],
      totalCorrect: json["totalCorrect"]

    );
  }

}

class LeaderboardResponse{
  final List<TableRow> rows;
  const LeaderboardResponse({required this.rows});

  factory LeaderboardResponse.fromJson(List<dynamic> json){

   List<LeaderboardEntries> list =  json.map((e)=>LeaderboardEntries.fromJson(e)).toList();
  List<TableRow>rows = [];
  int index = 1;
  for(LeaderboardEntries e in list){
    TableRow row = new TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text("$index", style: GoogleFonts.novaSquare(fontSize: 20))),
        Padding(padding: const EdgeInsets.all(8), child: Text("${e.username}", style: GoogleFonts.novaSquare(fontSize: 20))),
        Padding(padding: const EdgeInsets.all(8), child: Text(e.totalAnswered.toString(), style: GoogleFonts.novaSquare(fontSize:20))),
        Padding(padding: const EdgeInsets.all(8), child: Text(e.totalCorrect.toString(), style: GoogleFonts.novaSquare(fontSize:20))),
      ],
    );
    rows.add(row);
  }
  return LeaderboardResponse(rows: rows);
  }
}

class GetQuestion{

  String sessionId;
  String firstQuestion;
  List<String> options;

  GetQuestion({required this.sessionId, required this.firstQuestion, required this.options});

  factory GetQuestion.fromJson(Map<String, dynamic> json){
    return GetQuestion(
      sessionId: json["sessionId"],
      firstQuestion: json["firstQuestion"],
      options: List<String>.from(json["options"])
    );
  }

}

class CheckQuestion{

  String sessionId;
  bool wasCorrect;
  String correctAnswer;
  String nextQuestion;
  List<String> option;

  CheckQuestion({required this.sessionId, required this.wasCorrect, required this.correctAnswer, required this.nextQuestion, required this.option});

  factory CheckQuestion.fromJson(Map<String, dynamic> json){
    return CheckQuestion(
      sessionId: json["sessionId"],
      wasCorrect: json["wasCorrect"],
      correctAnswer: json["correctAnswer"],
      nextQuestion: json["nextQuestion"],
      option: List<String>.from(json["options"])
    );
  }

}

