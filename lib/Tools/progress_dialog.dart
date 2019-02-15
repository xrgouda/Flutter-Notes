import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text("Please Wait...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


displayProgressDialog(BuildContext context) {
  Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext, _, __) {
    return ProgressDialog();
  }));
}

closeProgressDialog(BuildContext context) {
  Navigator.pop(context);
}