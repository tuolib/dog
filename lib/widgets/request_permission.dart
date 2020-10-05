import 'dart:math';
import 'dart:io';
import 'dart:convert';

import '../index.dart';

class RequestPermissionWidget extends StatefulWidget {
  final String avatarUrl;
  final String avatarLocal;
  final String firstName;
  final String lastName;
  final int colorId;
  final double width;
  final double height;
  final double fontSize;

  RequestPermissionWidget({
    Key key,
    this.avatarUrl,
    this.avatarLocal,
    this.firstName,
    this.lastName,
    this.colorId,
    this.width,
    this.height,
    this.fontSize,
  }) : super(key: key);

  @override
  _RequestPermissionWidgetState createState() => _RequestPermissionWidgetState();
}

class _RequestPermissionWidgetState extends State<RequestPermissionWidget> {
  List colors = Colors.primaries;
  static Random random = Random();
  int rNum = random.nextInt(18);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Leave group"),
            ),
          ],
        ),
      ),
      content: Text.rich(TextSpan(children: [
        TextSpan(text: "Are you sure you want to delete"),
        TextSpan(text: " and leave the group "),
        TextSpan(
          text: "12",
          style: TextStyle(
            fontWeight: FontWeight.bold,
//                        color: Colors.blue
          ),
        ),
        TextSpan(text: "?"),
      ])),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(
            'DELETE CHAT',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {

          },
        ),
      ],
    );
  }
}
