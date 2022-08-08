import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  @override
  NotificationWidgetState createState() => NotificationWidgetState();
}

class NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('Notification Title'),
              subtitle: Text(
                  'Up to 20% off on al shampoo . shop Use promo code a123'),
              trailing: Icon(Icons.close),
            ),
          ),
        ),
      ),
    );
  }
}
