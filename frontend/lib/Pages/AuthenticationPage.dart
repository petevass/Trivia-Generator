import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/auth/authfunctions.dart';

enum AuthPage { LOGIN, REGISTER }

class AuthenticationPage extends StatefulWidget {
  final AuthPage? page;

  const AuthenticationPage({super.key, this.page});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController usernameTec = TextEditingController();
  final TextEditingController passTec = TextEditingController();
  final TextEditingController usernameTecRegister = TextEditingController();
  final TextEditingController passTecRegister = TextEditingController();

  String error = "";

  @override
  void dispose() {
    usernameTec.dispose();
    passTec.dispose();
    usernameTecRegister.dispose();
    passTecRegister.dispose();
    super.dispose();
  }

  void setError(String message) {
    setState(() {
      error = message;
    });
  }

  Widget getRegister() {
    return Container(
      width: 500,
      constraints: const BoxConstraints(maxHeight: 650),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        border: Border.all(color: Colors.blue),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error.isNotEmpty) ...[
              Container(
                alignment: Alignment.center,
                width: 425,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900, width: 3),
                ),
                child: Text(
                  error,
                  style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.red.shade900),
                ),
              ),
              const SizedBox(height: 15),
            ],
            Text(
              "Register",
              style: GoogleFonts.novaSquare(fontSize: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),

            Text(
              "Username",
              style: GoogleFonts.novaSquare(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: usernameTecRegister,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Password",
              style: GoogleFonts.novaSquare(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: passTecRegister,
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                int code = await Register(usernameTecRegister.text, passTecRegister.text);
                if (!mounted) return;

                if (code != 200) {
                  setError("This Username Already Has An Account");
                } else {
                  setError("");
                  Navigator.pushReplacementNamed(context, "/");
                }
              },
              child: const Text("Register"),
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setError("");
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: const Text("Log in"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getLogIn() {
    return Container(
      width: 500,
      constraints: const BoxConstraints(maxHeight: 650),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        border: Border.all(color: Colors.blue),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error.isNotEmpty) ...[
              Container(
                alignment: Alignment.center,
                width: 425,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900, width: 3),
                ),
                child: Text(
                  error,
                  style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.red.shade900),
                ),
              ),
              const SizedBox(height: 15),
            ],
            Text(
              "Log In",
              style: GoogleFonts.novaSquare(fontSize: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),

            Text(
              "Username",
              style: GoogleFonts.novaSquare(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: usernameTec,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Password",
              style: GoogleFonts.novaSquare(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: passTec,
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                int status = await Authenticate(usernameTec.text, passTec.text);
                if (!mounted) return;

                if (status == 403) {
                  setError("Username and Password do not work");
                } else if (status == 200) {
                  setError("");
                  Navigator.pushReplacementNamed(context, "/");
                }
              },
              child: const Text("Log In"),
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an Account?",
                  style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setError("");
                    Navigator.pushReplacementNamed(context, "/register");
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.page == AuthPage.REGISTER ? getRegister() : getLogIn(),
      ),
    );
  }
}