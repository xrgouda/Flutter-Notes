import 'package:flutter/material.dart';
import 'package:notes/Tools/progress_dialog.dart';
import 'package:notes/Tools/snackBar.dart';
import 'package:notes/Login_Signup/userManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();

  String _emailValue;
  String _passwordValue;
  String _nameValue;


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
                      fit: BoxFit.cover)),
              child: new Column(children: <Widget>[

                //Name TextField
                new Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 100.0),
                  height: 52.0,
                  width: 320.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: TextField(
                    controller: fullName,
                    onChanged: (value) {
                      _nameValue = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Full Name",
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

                //Email TextField
                new Container(
                  alignment: Alignment.center,
                  height: 52.0,
                  width: 320.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: TextField(
                    controller: email,
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

                //Password TextField
                new Container(
                  alignment: Alignment.center,
                  height: 52.0,
                  width: 320.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: TextField(
                    controller: password,
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
                  height: 35.0,
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
                      onPressed: () {
                        if (fullName.text == "") {
                          showSnackBar("Full Name Cannot Be Empty!", scaffoldKey);
                          return;
                        }
                        if (email.text == "") {
                          showSnackBar("Email Cannot Be Empty!", scaffoldKey);
                          return;
                        }
                        if (password.text == "") {
                          showSnackBar("Password Cannot Be Empty!", scaffoldKey);
                          return;
                        }
                         displayProgressDialog(context);

                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailValue, password: _passwordValue)
                            .then((signedInUser) {
                          CreateUser()
                              .storeNewUser(signedInUser, context);
                        });
                      },
                    )),
              ])),
        ));
  }

}
