import 'package:notes/Main_Page.dart';
import 'package:notes/Notes/Note_References/add_note.dart';
import 'package:notes/Notes/Note_References/edit_notes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleNotes extends StatefulWidget {
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  GoogleNotes({this.user, this.googleSignIn});

  @override
  _GoogleNotesState createState() => _GoogleNotesState();
}

class _GoogleNotesState extends State<GoogleNotes> {

  //Sign Out Alert Dialog
  void signOut() async {
    return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              content: Container(
                height: 215.0,
                child: new Column(
                  children: <Widget>[
                    new ClipOval(
                      child: Image.network(widget.user.photoUrl),
                    ),
                    SizedBox(height: 10.0),
                    new Text("Sign Out?",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "UbuntuBold")),
                    new Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        new InkWell(
                          onTap: () {
                            widget.googleSignIn.signOut();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => MainPage()));
                          },
                          child: new Column(
                            children: <Widget>[
                              Icon(Icons.check,size: 30),
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

            //show Notes With Stream Builder
            child: StreamBuilder(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(left: 15.0),
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.user.photoUrl),
                              fit: BoxFit.cover)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                      child: Text(
                        widget.user.displayName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "UbuntuBold"),
                      ),
                    ),
                  ],
                ),
                new IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => signOut(),
                  color: Colors.red,
                  iconSize: 40.0,
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

        return Dismissible(
          key: Key(widget.document[i].documentID),
          onDismissed: (direction) {
            Firestore.instance.runTransaction((Transaction transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(widget.document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                "Note Is Deleted",
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 19.0),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.black87,
            ));
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 17.0, left: 1.0),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: "UbuntuBold",
                              color: Colors.black54),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              dateText,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.w300, fontFamily: "UbuntuMedium"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
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
                              child: Text(
                            notes,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: "UbuntuMedium"),
                          )),
                        ],
                      ),
                      Divider(
                        height: 17.0,
                      ),
                    ],
                  ),
                ),

                //Edit Notes
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
