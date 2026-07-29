import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class Index extends StatelessWidget {
  const Index({super.key});
  final String title = "Trivia Generator";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,

              padding: const EdgeInsets.only(bottom: 40),
              color: Colors.blueAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Container(
                      child: Row(
                          children: [
                            Text(
                                "Test Your",
                                style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white)
                            ),
                            const Spacer(),
                            Container(

                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                  "TG",
                                  style: GoogleFonts.novaSquare(fontSize: 100, color: Colors.white)
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 50),
                                child: const Icon(Icons.question_mark, size: 100)
                            )
                          ]
                      )
                  ),
                  Text("Knowledge", style: GoogleFonts.novaSquare(fontSize: 50, color: Colors.white)),
                  const SizedBox(height: 50),
                  const Text(
                      "Challenge yourself with thousands of trivia questions across \n "
                          "dozens of categories. Compete on the leaderboard and track your"
                          "\n progress.",
                      style: TextStyle(fontSize: 20, color: Colors.white)
                  )
                ],
              ),
            ),
            Container(

              width: width,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.purpleAccent.shade700,
              child: Wrap(
                alignment: WrapAlignment.center,

                spacing: 40,
                runSpacing: 40,
                children: [
                  Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          border: Border.all(color: Colors.purpleAccent.shade100),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Over 24 Different Categories", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("From Celebrities to Math to\n Computers to General Knowledge,\n there is something for everyone", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                  ),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        border: Border.all(color: Colors.purpleAccent.shade100),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Track Your Progress", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Stats such as how many \n questions you answered and how \n many you answered correctly are \n tracked so you can actively watch \n as you improve", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                            )
                          ]
                      ),
                    ),
                  ),
                  Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.purpleAccent,
                          border: Border.all(color: Colors.purpleAccent.shade100),
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Compete Against Others", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Every time you complete a set of trivia questions, your stats increase and place you on a global leaderboard, allowing you to participate in a worldwide competition", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
