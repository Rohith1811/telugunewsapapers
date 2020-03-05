import 'package:flutter/material.dart';
class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificatios'),
        flexibleSpace:  Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Color(0xFFB71C1C),
                Color(0xFFD32F2F),
                Color(0xFFE53935),
              ],

            ),
          ),
        ),
      ),
      body: Center(
        child: Text('There are no notificatios.'),
      ),
    );
  }
}
