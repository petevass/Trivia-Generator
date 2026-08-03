import "package:flutter/material.dart";
import "package:frontend/API/fetch.dart";
import "package:google_fonts/google_fonts.dart";

class Leaderboard extends StatelessWidget {
  final fetch f = fetch();

  TableRow _headerRow() {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text("Rank ", style: GoogleFonts.novaSquare(fontSize: 35))),
        Padding(padding: const EdgeInsets.all(8), child: Text("Name ", style: GoogleFonts.novaSquare(fontSize: 35))),
        Padding(padding: const EdgeInsets.all(8), child: Text("Answered ", style: GoogleFonts.novaSquare(fontSize: 35))),
        Padding(padding: const EdgeInsets.all(8), child: Text("Correct ", style: GoogleFonts.novaSquare(fontSize: 35))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, size: 60),
                        Text("Leaderboard", style: GoogleFonts.novaSquare(fontSize: 55)),
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Ranked By Total Answered", style: GoogleFonts.novaSquare(fontSize: 20)),
                        SizedBox(width: 400),
                        Text("Ranked By Correctly Answered", style: GoogleFonts.novaSquare(fontSize: 20)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        FutureBuilder<List<TableRow>>(
                          future: f.fetchTotalLeaderboard(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text("Failed to load: ${snapshot.error}"),
                              );
                            }

                            final rows = snapshot.data ?? [];

                            return Table(
                              border: TableBorder.all(),
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                _headerRow(),
                                ...rows,
                              ],
                            );
                          },
                        ),
                        SizedBox(width: 60),

                        FutureBuilder<List<TableRow>>(
                          future: f.fetchCorrectLeaderboard(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text("Failed to load: ${snapshot.error}"),
                              );
                            }

                            final rows = snapshot.data ?? [];

                            return Table(
                              border: TableBorder.all(),
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                _headerRow(),
                                ...rows,
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}