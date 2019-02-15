import 'package:notes/Main_Page.dart';
import 'package:notes/Notes/Note_References/add_note.dart';
import 'package:notes/Notes/Note_References/edit_notes.dart';
import 'package:notes/Tools/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesPage extends StatefulWidget {
  final FirebaseUser user;
  final FirebaseAuth auth;

  NotesPage({this.user, this.auth});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  //Sign Out Alert Dialog
  void signOut() async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              content: Container(
                height: 200.0,
                child: new Column(
                  children: <Widget>[
                    new ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 55.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new Text("Sign Out?",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "UbuntuBold")),
                    new Divider(),
                    SizedBox(height: 30.0),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new InkWell(
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MainPage()));
                            }).catchError((e) {
                              showSnackBar(e, scaffoldKey);
                              print(e);
                            });
                          },
                          child: new Column(
                            children: <Widget>[
                              Icon(Icons.check, size: 30),
                              SizedBox(height: 5.0),
                              Text("Yes",style: TextStyle(fontFamily: "UbuntuMedium")),
                            ],
                          ),
                        ),
                        new InkWell(
                          onTap: () => Navigator.pop(context),
                          child: new Column(
                            children: <Widget>[
                              Icon(Icons.cancel, size: 30),
                              SizedBox(height: 5.0),
                              Text("Cancel",style: TextStyle(fontFamily: "UbuntuMedium")),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddNote(email: widget.user.email))),
        child: Icon(Icons.add),
        backgroundColor: Colors.black87,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.black87,
        elevation: 20.0,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 180.0),
            child: StreamBuilder(
              //Save to firestore
              stream: Firestore.instance
                  .collection("Notes")
                  .where("email", isEqualTo: widget.user.email)
                  .snapshots(),

              builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return TaskList(document: snapshot.data.documents);
              },
            ),
          ),
          new Container(
            height: 195.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/black-wood.jpg"),
                fit: BoxFit.cover,
              ),
              boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 3.0)],
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //Exit Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => signOut(),
                    color: Colors.red,
                    iconSize: 43.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final List<DocumentSnapshot> document;

  TaskList({this.document});

  @override
  TaskListState createState() {
    return new TaskListState();
  }
}

class TaskListState extends State<TaskList> {
  final DateTime dateTime = DateTime.now();

  String dateText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateText = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.document.length,
      itemBuilder: (_, int i) {
        String title = widget.document[i].data['title'].toString();
        String notes = widget.document[i].data['notes'].toString();

        //Delete Note
        return Dismissible(
          key: Key(widget.document[i].documentID),
          onDismissed: (direction) {
            Firestore.instance.runTransaction((Transaction transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(widget.document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Note Is Deleted",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "UbuntuBold",
                        fontWeight: FontWeight.w500,
                        fontSize: 19.0),
                    textAlign: TextAlign.center),
                backgroundColor: Colors.black87));
          },
          child: Padding(
            padding:
                const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Note Title
                      Padding(
                        padding: const EdgeInsets.only(bottom: 17.0, left: 1.0),
                        child: Text(title,
                            style: TextStyle(
                                fontSize: 28.0,
                                fontFamily: "UbuntuBold",
                                color: Colors.black87)),
                      ),

                      //Note Date
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15.0),
                            child:
                                Icon(Icons.date_range, color: Colors.blueGrey),
                          ),
                          Text(dateText,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "UbuntuMedium")),
                        ],
                      ),
                      SizedBox(height: 12.0),

                      //Note Details
                      new Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 12.0, top: 2.0),
                            child: Icon(
                              Icons.note,
                              color: Colors.amber,
                            ),
                          ),
                          Expanded(
                              child: Text(notes,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontFamily: "UbuntuMedium"))),
                        ],
                      ),
                      Divider(height: 17.0),
                    ],
                  ),
                ),

                //Edit Note
                new IconButton(
                  icon: Icon(Icons.edit, size: 31.0, color: Colors.brown),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditNotes(
                              title: title,
                              note: notes,
                              dateTime: widget.document[i].data[dateText],
                              index: widget.document[i].reference,
                            ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
