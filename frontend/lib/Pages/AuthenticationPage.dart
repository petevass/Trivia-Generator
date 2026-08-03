import 'package:frontend/auth/authfunctions.dart';
import'package:web/web.dart' as web;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AuthenticationPage extends StatefulWidget{

  AuthPage? page;

  AuthenticationPage({super.key, this.page});





  @override
  State<StatefulWidget> createState() {
    return AuthenticationPageState(page);
  }}

class AuthenticationPageState extends State<AuthenticationPage> {
   AuthPage? page;
   final TextEditingController usernameTec = TextEditingController();
   final TextEditingController passTec = TextEditingController();
    String error = "";
   final TextEditingController usernameTecRegister = TextEditingController();
   final TextEditingController passTecRegister = TextEditingController();
  AuthenticationPageState(this.page);

  @override
  void dispose(){
    usernameTec.dispose();
    passTec.dispose();
    super.dispose();
  }



  void setError(String error){
    setState(() {
      this.error = error;
    });
  }

  Widget getRegister(){
    return Container(
        width:500,
        height:500,

        decoration: BoxDecoration(
            color: Colors.blue.shade400,
            border: Border.all(
                color: Colors.blue
            )
        ),
        child: Center(
            child: Column(
                children: [
                  SizedBox(
                    height:15
                  ),
                  Container(
                    alignment: AlignmentGeometry.center,
                    width: error == "" ? 0 : 425,
                    height: error == "" ? 0: 35,
                    decoration: error == "" ? null : BoxDecoration(
                        border: Border.all(color: Colors.red.shade900, width: 3)
                    ),
                    child: Text(error,
                        style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.red.shade900)
                    ),
                  ),
                  Text("Register", style: GoogleFonts.novaSquare(fontSize: 40, color: Colors.white),),

                  SizedBox(height:20),

                  Text("Username", style: GoogleFonts.novaSquare(fontSize: 20, color:Colors.white)),
                  SizedBox(
                      width:500*.80,
                      child:TextField(
                        controller: usernameTecRegister,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white
                        ),
                      )
                  ),
                  SizedBox(height:40),
                  Text(
                    "Password",
                    style: GoogleFonts.novaSquare(fontSize:20, color: Colors.white),
                  ),
                  SizedBox(
                      width:500*.80,
                      child:TextField(
                        controller: passTecRegister,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white
                        ),
                      )
                  ),
                  SizedBox(height:40),
                  ElevatedButton(onPressed: ()async {
                    int code = await Register(usernameTecRegister.text, passTecRegister.text);
                    if(code != 200){
                      setError("This Username Already Has An Account");

                    }else if(code == 200){
                      setError("");
                      Navigator.pushReplacementNamed(context, "/");
                    }

                  }, child: Text("Register")),

                  SizedBox(height: 60),
                  Row(
                    children: [
                      SizedBox(width: 100),
                      Text("Already have an Account?",
                          style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.white)
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(onPressed: (){
                        Navigator.pushReplacementNamed(context,"/login");
                      }, child: Text("Log in"))
                    ],
                  )
                ]
            )
        )
    );
  }

  Widget getLogIn(){
    return Container(
        width:500,
        height:500,

        decoration: BoxDecoration(
            color: Colors.blue.shade400,
            border: Border.all(
                color: Colors.blue
            )
        ),
        child: Center(
            child: Column(
                children: [
                  SizedBox(
                    height:15
                  ),
                  Container(
                    alignment: AlignmentGeometry.center,
                    width: error == "" ? 0 : 425,
                    height: error == "" ? 0: 35,
                    decoration: error == "" ? null : BoxDecoration(
                      border: Border.all(color: Colors.red.shade900, width: 3)
                    ),
                    child: Text(error,
                        style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.red.shade900)
                    ),
                  ),
                  Text("Log In", style: GoogleFonts.novaSquare(fontSize: 40, color: Colors.white),),

                  SizedBox(height:20),

                  Text("Username", style: GoogleFonts.novaSquare(fontSize: 20, color:Colors.white)),
                  SizedBox(
                      width:500*.80,
                      child:TextField(
                        controller: usernameTec,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                                                    ),
                      )
                  ),
                  SizedBox(height:40),
                  Text(
                    "Password",
                    style: GoogleFonts.novaSquare(fontSize:20, color: Colors.white),

                  ),
                  SizedBox(
                      width:500*.80,
                      child:TextField(
                        controller: passTec,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white
                        ),
                      )
                  ),
                  SizedBox(height:40),
                  ElevatedButton(onPressed: ()async {
                    int status = await Authenticate(usernameTec.text, passTec.text);
                    if(status == 403){
                      setError("Username and Password do not work");
                    }else if(status == 200){
                      setError("");
                      Navigator.pushReplacementNamed(context, "/");
                    }
                  }, child: Text("Log In")),

                  SizedBox(height: 60),
                  Row(
                    children: [
                      SizedBox(width: 100),
                      Text("Don't have an Account?",
                          style: GoogleFonts.novaSquare(fontSize: 15, color: Colors.white)
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(onPressed: (){Navigator.pushReplacementNamed(context, "/register");}, child: Text("Register"))
                    ],
                  )
                ]
            )
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: this.page == AuthPage.REGISTER ? getRegister() : getLogIn()



      ),
    );
  }

}

enum AuthPage{
  LOGIN,
  REGISTER
}