import 'package:flutter/material.dart';
import 'package:notes/Notes/Email_Notes.dart';
import 'package:notes/Tools/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/Tools/snackBar.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailTextController = TextEditingController();

  TextEditingController passwordTextController = TextEditingController();

  String _emailValue;
  String _passwordValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/black-wood.jpg"),
                fit: BoxFit.cover,
              )),
              child: new Column(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 100.0),
                    alignment: Alignment.center,
                    height: 52.0,
                    width: 330.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextField(
                      controller: passwordTextController,
                      onChanged: (value) {
                        setState(() {
                          _emailValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "UbuntuMedium"),
                        contentPadding: EdgeInsets.only(left: 15.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    height: 52.0,
                    width: 330.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextField(
                      controller: emailTextController,
                      onChanged: (value) {
                        setState(() {
                          _passwordValue = value;
                        });
                      },
                      obscureText: _secureText,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: showHide,
                          icon: Icon(_secureText ? Icons.visibility: Icons.visibility_off),
                        ),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "UbuntuMedium"),
                        contentPadding: EdgeInsets.all(15.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27.0,
                  ),
                  new Container(
                      height: 55.0,
                      width: 250.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.indigo,
                            Colors.blueGrey.withBlue(160)
                          ]),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: FlatButton(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: "UbuntuBold"),
                        ),
                        onPressed: () {
                          if (emailTextController.text == "") {
                            showSnackBar("Email Cannot Be Empty!", scaffoldKey);
                            return;
                          }
                          if (passwordTextController.text == "") {
                            showSnackBar(
                                "Password Cannot Be Empty", scaffoldKey);
                            return;
                          }
                          displayProgressDialog(context);
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailValue, password: _passwordValue)
                              .then((FirebaseUser user) {
                                closeProgressDialog(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotesPage(user: user),
                                ));
                          }).catchError((e) {
                            closeProgressDialog(context);
                            showSnackBar(e.toString(), scaffoldKey);
                            print(e);
                          });
                        },
                      )),
                ],
              )),
        ));
  }
}
