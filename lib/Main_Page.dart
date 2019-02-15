import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes/Login_Signup/signup_page.dart';
import 'package:notes/Login_Signup/login_page.dart';
import 'package:notes/Notes/Google_Notes.dart';
import 'dart:core';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Google SignIn
  Future<String> googleLogin() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    FirebaseUser firebaseUser = await auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => GoogleNotes(
                  user: firebaseUser,
                  googleSignIn: googleSignIn,
                )));
    return firebaseUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          //Background Image
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/black-wood.jpg'),
                fit: BoxFit.cover),
          ),

          //Note Picture
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                "assets/images/note.png",
                height: 150.0,
                width: 210.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),

            //SignUp Button
            Container(
                height: 55.0,
                width: 260.0,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.green, Colors.teal]),
                    borderRadius: BorderRadius.circular(25.0)),
                child: FlatButton(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "UbuntuBold"),
                  ),
                  textColor: Colors.white,
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SignupPage())),
                )),
            SizedBox(
              height: 20.0,
            ),

            //Login Button
            Container(
                height: 55.0,
                width: 260.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueGrey.withBlue(160)]),
                    borderRadius: BorderRadius.circular(25.0)),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: "UbuntuBold"),
                  ),
                  textColor: Colors.white,
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginPage())),
                )),
            SizedBox(
              height: 25.0,
            ),

            Container(
                child: Text(
              "OR",
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900),
            )),
            SizedBox(
              height: 25.0,
            ),

            //Google SignIn Button
            new InkWell(
              onTap: googleLogin,
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20.0, bottom: 20.0),
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27.0),
                    color: Colors.red),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(FontAwesomeIcons.google,
                        color: Colors.white, size: 40.0),
                    Container(
                      child: Text(
                        "oogle",
                        style: TextStyle(
                          fontSize: 27.0,
                          color: Colors.white,
                          fontFamily: "UbuntuMediumItalic",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
