import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.userName, this.message, this.userImage, this.userMe,
      {this.key});
  final String userName;
  final String userImage;
  final Key key;
  final String message;
  final bool userMe;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment:
              userMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color:
                    userMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !userMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        userMe ? Radius.circular(0) : Radius.circular(12)),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    userMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(
                        color: userMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: userMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.title.color),
                    textAlign: userMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: -10,
            left: userMe ? null : 120,
            right: userMe ? 120 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            )),
      ],
      overflow: Overflow.visible,
    );
  }
}
