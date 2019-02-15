import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/Notes/Email_Notes.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/Tools/progress_dialog.dart';

class CreateUser {
  final String email;
  final String password;
  final String fullName;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  CreateUser({this.email,this.password, this.fullName});

  storeNewUser(user, context) {
    Firestore.instance.collection('/user').document(user.uid).setData({
      'email': user.email,
      'uid': user.uid,
    }).then((value){
      closeProgressDialog(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => NotesPage(user: user)));
    }).catchError((e){
      print(e);
    });
  }
}