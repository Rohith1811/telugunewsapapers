import 'dart:convert';
import 'dart:core';
//import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telugu_ap_ts_news_papers/Models/postjson.dart';
import 'Notificationspage.dart';
import 'Individualpaper.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:telugu_ap_ts_news_papers/Models/jsondata.dart';
import 'package:telugu_ap_ts_news_papers/api/api_imp.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';


void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(homepage());
  });
}

class homepage extends StatelessWidget {
  const homepage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
      ),
      title: 'newsapp',
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  final String fcmtoken;
  final String deviceid;
  Homepage({Key key, this.deviceid, this.fcmtoken}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Jsondata jsondata = Jsondata();

  String ImgURL = 'http://telugupaper.in/news/';
  var imgurl;
  var response;
  bool _isinterstialAdloaded = false;

  Future getCatData() async {
    _isloading = true;
    var catJson =
        await CatAPI().getnewscategories(widget.deviceid, widget.fcmtoken);
    print(catJson);

    var catMap = json.decode(catJson);
    setState(() {
      jsondata = Jsondata.fromJson(catMap);
    });
  }

  List mytabs() {
    return List<Widget>.generate(jsondata.categorisedList.length, (int index) {
      //print(categories[0]);
      return new Tab(
        text: jsondata.categorisedList[index].categoryName,
      );
    });
  }

  TabController controller;
  var length;
  var categoryid;
  var subcatid;
  var subcatname;
  bool _isloading;
  bool _issubcatempty;
  var categoryName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookAudienceNetwork.init();


    getCatData().then((res) {
      setState(() {
        response = res;
        _isloading = false;
        _issubcatempty = false;
      });
    });
  }

  bool isscrollabe(int scroll) {
    if (scroll == 2) {
      return false;
    } else {
      return true;
    }
  }

  @override


  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Widget _currentAd = FacebookBannerAd(
    placementId:"189219202298497_189221475631603",
    bannerSize: BannerSize.STANDARD,
    listener: (result,value){
      print('BannerAd:$result --> $value');
    },
  );



  telanganapaper(int pos) {
    return jsondata.categorisedList[pos].subCategories.length <= 0
        ? Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Image.asset('assets/Notupdated.png'),
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              new GridView.count(
                primary: true,
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                childAspectRatio: 1,
                children: List.generate(
                    jsondata.categorisedList[pos].subCategories.length,
                    (index) {
                  imgurl =
                      jsondata.categorisedList[pos].subCategories[index].image;
                  /*if (jsondata.categorisedList[pos].subCategories.length <= 0) {
            setState(() {
              _issubcatempty = true;
            });
          }*/
                  return GestureDetector(
                    onTap: () {
                      categoryid = jsondata.categorisedList[pos].categoryId;
                      subcatid =
                          jsondata.categorisedList[pos].subCategories[index].id;
                      subcatname = jsondata
                          .categorisedList[pos].subCategories[index].subCatName;
                      categoryName = jsondata.categorisedList[pos].categoryName;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Inidvidualpaper(
                                  categid: categoryid,
                                  subcatid: subcatid,
                                  categoryName: categoryName,
                                  subcatname: subcatname)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        //semanticContainer: true,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.network(ImgURL + imgurl,
                                  height: 110, width: 110),
                              SizedBox(
                                height: 14.0,
                              ),
                              Text(
                                jsondata.categorisedList[pos]
                                    .subCategories[index].subCatName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    fontFamily: 'ArmWrestler'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Align(alignment: Alignment(0, 1), child: _currentAd),
                  ),
                ]
              )
            ],
          );
  }

  /*shcdowinterstialad() {
    if (_isinterstialAdloaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      print('no interstial ad');
    }
  }*/

  Future<bool> _willPopCallback() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Are you sure you want to exit",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              content: Container(height: 20),
              actions: <Widget>[
                GestureDetector(
                  child: FlatButton(
                    child: Text('RATE OUR APP',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    onPressed: () {
                      print('ratemyapp');
                    },
                  ),
                ),
                GestureDetector(
                  child: FlatButton(
                    child: Text('CANCEL',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
                GestureDetector(
                  child: FlatButton(
                    child: Text('YES',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading == true) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    /*Color.fromRGBO(70, 71, 115, 3),
                    Color.fromRGBO(70, 71, 113, 3),
                    Color.fromRGBO(70, 71, 110, 3)*/
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
    } else {
      return WillPopScope(
        child: DefaultTabController(
          length: jsondata.categorisedList.length,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(130.0),
              child: AppBar(
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                          onTap: () {
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notifications()));
                          },
                          child: Icon(Icons.notifications)),
                    )
                  ],
                  title: Text('Home'),
                  flexibleSpace: Container(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        colors: [
                          /* Color.fromRGBO(70, 71, 115, 3),
                        Color.fromRGBO(70, 71, 113, 3),
                        Color.fromRGBO(70, 71, 110, 3)*/

                          Color(0xFFB71C1C),
                          Color(0xFFD32F2F),
                          Color(0xFFE53935),
                        ],
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Marquee(
                          text: jsondata.scroll_text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0),
                          blankSpace: 100.0,
                        )),
                  ),
                  bottom: TabBar(
                    labelStyle: TextStyle(
                        fontFamily: 'ArmWrestler',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    isScrollable: isscrollabe(jsondata.categorisedList.length),
                    tabs: mytabs(),
                    indicatorColor: Colors.green,
                  )),
            ),
            drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        /*Color.fromRGBO(70, 71, 115, 3),
                      Color.fromRGBO(70, 71, 113, 3),
                      Color.fromRGBO(70, 71, 110, 3)*/
                        Color(0xFFB71C1C),
                        Color(0xFFD32F2F),
                        Color(0xFFE53935),
                      ],
                    )),
                    child: Center(
                        child: Text(
                      'TS & AP News Papers',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  ListTile(
                    title: Text(
                      'Home',
                    ),
                    leading: Icon(Icons.home, color: Colors.black),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),


                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.black),
                    title: Text('Notifications'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notifications()));
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share, color: Colors.black),
                    title: Text('Share'),
                    onTap: () {
                      Share.share("hi with");
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: Image.asset('assets/policy.png'),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),

                ],
              ),
            ),
            body: new TabBarView(
              children: List<Widget>.generate(jsondata.categorisedList.length,
                  (int index) {
                return telanganapaper(index);
              }),
            ),
          ),
        ),
        onWillPop: _willPopCallback,
      );
    }
  }
}
