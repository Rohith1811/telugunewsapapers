import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Homepage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_id/device_id.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
        ),
        home: Splashscreen());
  }
}

class Splashscreen extends StatefulWidget {
  Splashscreen({Key key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];
  var _token;
  bool _isinterstialAdloaded =false;
  String deviceid;
  void handleTimeout() {
   /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Homepage(
                  deviceid: deviceid,
                  fcmtoken: _token,
                )));*/
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        maintainState: true,
        builder: (BuildContext context) => new Homepage(deviceid: deviceid,fcmtoken: _token, )));
  }

  Future<String> _getId() async {
    return deviceid = await DeviceId.getID;
    
  }

  @override
  void initState() {
    super.initState();

    setState(() {

    });
    _getId().then((id) {
      deviceid = id;
      print(id);
    });
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      setState(() {
        _token = token;
      });
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> notification) async {
          setState(() {
            notifications.add(
              Notification(
                title: notification["notification"]["title"],
                body: notification["notification"]["body"],
                color: Colors.red,
              ),
            );
          });
        },
        onLaunch: (Map<String, dynamic> notification) async {
          setState(() {
            notifications.add(
              Notification(
                title: notification["notification"]["title"],
                body: notification["notification"]["body"],
                color: Colors.green,
              ),
            );
          });
        },
        onResume: (Map<String, dynamic> notification) async {
          setState(() {
            notifications.add(
              Notification(
                title: notification["notification"]["title"],
                body: notification["notification"]["body"],
                color: Colors.blue,
              ),
            );
          });
        },
      );
    });
    Timer(Duration(seconds: 3), () => handleTimeout());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  /*Color.fromRGBO( 70, 71, 115,3),
                                    Color.fromRGBO( 70, 71, 113,3),
                                    Color.fromRGBO( 70, 71, 110,3)*/
                  Color(0xFFB71C1C),
                  Color(0xFFD32F2F),
                  Color(0xFFE53935),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80.0,
                            child: Image.asset(
                              'assets/applogo2.png',
                              height: 110.0,
                              width: 110.0,
                            ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Notification {
  final String title;
  final String body;
  final Color color;
  const Notification(
      {@required this.title, @required this.body, @required this.color});
}
