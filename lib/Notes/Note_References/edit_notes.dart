import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditNotes extends StatefulWidget {

  final String title;
  final String note;
  final DateTime dateTime;
  final index;
  EditNotes({this.dateTime,this.note,this.title, this.index});

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {


  TextEditingController titleController;
  TextEditingController notesController;

  DateTime dateTime = DateTime.now();
  String dateText = "";

  String title = "";
  String notes = "";


  void editNote() async{
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot =
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "title": title,
        "notes": notes,
        "dateTime": dateTime
      });
    });

    Navigator.pop(context);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dateText = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

    title = widget.title;
    notes = widget.note;

    titleController = TextEditingController(text: widget.title);
    notesController = TextEditingController(text: widget.note);
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
                controller: titleController,
                onChanged: (String str){
                  setState(() {
                    title = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.dashboard),
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 25.0, fontFamily: "UbuntuMedium"),
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 25.0, fontFamily: "UbuntuMedium", color: Colors.black),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(right: 13.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(padding : EdgeInsets.only(right: 12.0),child: Icon(Icons.date_range, size: 40.0,color: Colors.blueGrey)),
                  Expanded(
                    child: Text("Date", style: TextStyle(
                        fontSize: 22.0, color: Colors.black87,fontFamily: "UbuntuBold")),
                  ),
                  Text(dateText, style: TextStyle(
                      fontSize: 22.0, color: Colors.black87, fontFamily: "UbuntuRegular")),
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: notesController,
                onChanged: (String str){
                  setState(() {
                    notes = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.note, size: 35.0,),
                    hintText: 'Note',
                    hintStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                    border: InputBorder.none
                ),
                style: TextStyle(fontSize: 25.0, fontFamily: "UbuntuMedium", color: Colors.black),
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
                    onPressed: () => editNote(),
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
