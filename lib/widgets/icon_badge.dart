import 'package:flutter/material.dart';
import '../index.dart';

class IconBadge extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;

  IconBadge({Key key, @required this.icon, this.size, this.color})
      : super(key: key);

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<IconBadge> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<ChatListModel>(context);
    var totalNews = notifier.totalNews;
    var totalStr = '';
    if (totalNews > 99) {
      totalStr = '99+';
    } else {
      totalStr = totalNews.toString();
    }
    return Stack(
      children: <Widget>[
        Icon(
          widget.icon,
          size: widget.size,
          color: widget.color ?? null,
        ),
        if (totalNews > 0)
          Positioned(
            right: 0.0,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 11,
                minHeight: 11,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 1),
                child: Text(
                  '$totalStr',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
