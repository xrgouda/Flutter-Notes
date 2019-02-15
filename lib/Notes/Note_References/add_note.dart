import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {

  final String email;
  AddNote({this.email});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  DateTime dateTime = DateTime.now();
  String dateText = "";

  String title = "";
  String notes = "";

  //Choose Date
//  Future<Null> _selectedDateTime (_) async {
//    final picked = await showDatePicker(
//      context: context,
//      initialDate: dateTime,
//      firstDate: DateTime(2018),
//      lastDate: DateTime(2080),
//    );
//    if (picked != null){
//      setState(() {
//        dateTime = picked;
//        dateText = "${picked.day}/${picked.month}/${picked.year}";
//      });
//    }
//  }

  void _addData() {
    Firestore.instance.runTransaction((Transaction transaction)async{
      CollectionReference reference = Firestore.instance.collection("Notes");
      await reference.add({
        "email": widget.email,
        "title": title,
        "dateTime": dateTime,
        "notes": notes
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateText = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new Container(
              height: 195.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/black-wood.jpg'),
                  fit: BoxFit.cover
                )
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Text('Add Note',
                  style: TextStyle(
                      fontSize: 34.0,
                      fontFamily: "UbuntuBold",
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                   ),
                  ),
                  SizedBox(height: 10.0,),
                  Icon(Icons.note_add, size: 60.0, color: Colors.white),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (String str){
                  setState(() {
                    title = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.dashboard),
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 25.0, fontFamily: "UbuntuMedium",fontWeight: FontWeight.w500),
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 25.0, fontFamily: "UbuntuMedium", fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(right: 13.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(padding : EdgeInsets.only(right: 12.0),child: Icon(Icons.date_range, size: 40.0,color: Colors.blueGrey,)),
                  Expanded(
                    child: Text("Date", style: TextStyle(
                        fontSize: 22.0, color: Colors.black87,fontFamily: "UbuntuMedium", fontWeight: FontWeight.w500)),
                  ),
                    Text(dateText, style: TextStyle(
                        fontSize: 22.0, color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: "UbuntuMedium")),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                onChanged: (String str){
                  setState(() {
                    notes = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.note, size: 35.0,),
                    hintText: 'Note',
                    hintStyle: TextStyle(fontSize: 25.0,fontFamily: "UbuntuBold"),
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 25.0, color: Colors.black, fontFamily: "UbuntuRegular"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 43.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 40.0,
                    onPressed: () => _addData(),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    iconSize: 40.0,
                    onPressed: ()=> Navigator.pop(context),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
