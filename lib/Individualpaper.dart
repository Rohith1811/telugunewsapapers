import 'dart:async';
import 'dart:convert';
import 'paperdisplaypage.dart';

import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telugu_ap_ts_news_papers/Models/postjson.dart';
import 'package:telugu_ap_ts_news_papers/api/api_imp.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice ="Mobile_id";

class Inidvidualpaper extends StatefulWidget {
  final String categid;
  final String subcatid;
  final String subcatname;
  final String categoryName;

  Inidvidualpaper({Key key, this.categid, this.subcatid, this.subcatname,this.categoryName})
      : super(key: key);

  @override
  _InidvidualpaperState createState() => _InidvidualpaperState();
}

class _InidvidualpaperState extends State<Inidvidualpaper> {
  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],


    childDirected: false,
    // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: testDevice!=null?<String>[testDevice]:null,
    nonPersonalizedAds: true// Android emulators are considered test devices
  );

  //var Date;
  bool _isloading = false;
  bool _ifDateVisible = false;
  var progress = "";
  var response;
  bool downloading = false;
  var selectedDate = DateTime.now();
  var progressString = "";
  Dio dio = Dio();
  var formatter;
  var formated;
  String downloadpath;
  var districtname;
  bool ismagazine;
  Postjson postjson = Postjson();
  String _version = 'Unknown';
  String _finalPath;
  var filepath;
  String pathurl = 'http://telugupaper.in/news/';
  String coverimageurl;
  String covermainimage;
  bool ismag;
  String videourl;

  Future getdistrictData() async {
    //     formated = {selectedDate.year.toString()+"-"+selectedDate.month.toString().padLeft(2, '0')+"-"+selectedDate.day.toString().padLeft(2, '0')};//formatter.format(DateTime.parse(selectedDate.toString()));

    _isloading = true;
    var catJson = await CatAPI().getdistrictpapers(
        widget.categid, widget.subcatid, selectedDate.toString());
    print(catJson);
    print(selectedDate);

    var catMap = json.decode(catJson);
    setState(() {
      postjson = Postjson.fromJson(catMap);

      if(widget.categoryName == "Magazines" || widget.categoryName == "Live Tv"||widget.categoryName == "Education"){
        _ifDateVisible = false;
      }
      else{
        _ifDateVisible = true;
      }
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-4319666597666027~1377060382").then((response){
      if(widget.categoryName == "Live Tv"){
        myInterstitial.dispose();
        myBanner.dispose();
      }
      else{

        myBanner..load()..show();
      }

    });


    getdistrictData();
  }
 void dispose(){
    super.dispose();
    myBanner.dispose();
    myInterstitial.dispose();
 }
  Future<bool> _willPopCallback() async {
    myInterstitial..load()..show();
  }

  BannerAd myBanner = BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: BannerAd.testAdUnitId,//"ca-app-pub-4319666597666027/7313489756",
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {

      print("BannerAd event is $event");
    },
  );

  InterstitialAd myInterstitial = InterstitialAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: InterstitialAd.testAdUnitId,//"ca-app-pub-4319666597666027/5229433659",
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );


   Future<void> filedownload() async {
 var dio = Dio();
 try{
   var dir = await getApplicationDocumentsDirectory();
   await dio.download(downloadpath, "${dir.path}/mypdf.pdf",
        onReceiveProgress: (rec, total) {
      setState(() {
        showViewer();
        downloading = true;
        progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
        print(progress);

      });
    });


 }catch(e){
   print(e);


 }
 setState(() {
   downloading = false;
    progress = "Completed";
 });

     }
  /*void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => displaypage()));
    } else {
      print('not working');
    }
  }*/
  /* void _showAlert(BuildContext context) {
    Dialog(
      child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new CircularProgressIndicator(),
        new Text("Loading...." + progressString)
      ]),
    );
  }*/

  datepicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate)
      //////formatter =  new DateFormat('yyyy-MM-dd');
      setState(() {
        selectedDate = picked;
        getdistrictData().then((res) {
          setState(() {
            response = res;
            _isloading = false;
          });
        });
      });
  }

  Widget mainpaper() {
    return postjson.mainPaper.length <= 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    border: Border.all(color: Colors.grey)),
                height: 270,
                width: 400,
                margin: EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'assets/Notupdated.png',
                                width: 200,
                              ),
                            ),
                            SizedBox(height: 120),
                            Container(
                              height: 40,
                              width: 395,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(
                                    'Main Edition',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              covermainimage = postjson.mainPaper[index].coverImage;

              return GestureDetector(
                onTap: () {
                  // Main Edition tap
                  //ismain = true;
                  loadPaper(postjson.mainPaper[index].pdf);
                },
                child: Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      postjson.mainPaper[index].coverImage.isEmpty
                          ? Container(
                              height: 220,
                              child: Center(
                                  child: Text(
                                'No Image Available',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              )))
                          : Image.network(
                              pathurl + covermainimage,
                              fit: BoxFit.fill,
                              height: 220,
                              width: 390,
                            ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                      Container(
                        height: 30,
                        width: 395,
                        child: Center(
                          child: Text(
                            'Main Edition',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget gridBuilder() {
    return GridView.builder(
      itemCount: postjson.papers.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        crossAxisCount: 2,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        coverimageurl = postjson.papers[index].coverImage;

        return GestureDetector(
          onTap: () {
            // District Tap
            //ismain= false;
            districtname = postjson.papers[index].districtName;
            videourl = postjson.papers[index].livetvurl;
            if (postjson.papers.length != 0 &&
                postjson.papers[0].type == "livetv") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => youtubepage(
                            videourl: videourl,
                          )));
            } else {
              loadPaper(postjson.papers[index].pdf);
            }
          },
          child: new Card(
              elevation: 4,
              //margin: EdgeInsets.symmetric(horizontal: 0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              borderOnForeground: true,
              child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    children: <Widget>[
                      coverimageurl.isEmpty
                          ? Expanded(
                              flex: 10,
                              child: AspectRatio(
                                aspectRatio: 2,
                                child: Center(
                                    child: Text(
                                  'No Image Available',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                )),
                              ),
                            )
                          : Expanded(
                              flex: 3,
                              child: AspectRatio(
                                aspectRatio: 2.5,
                                child: Image.network(pathurl + coverimageurl,
                                    fit: BoxFit.fill),
                              ),
                            ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.4,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0, left: 4.0, right: 4.0),
                              child: Text(
                                postjson.papers[index].districtName,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ))),
        );
      },
    );
  }

  Widget paperlist() {
    return postjson.papers.length <= 0
        ? Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Center(
              child: Text('Districts Editions Not Updated',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          )
        : gridBuilder();
  }

  Widget getpaperon() {
    if (postjson.papers.length != 0 && postjson.papers[0].type == "magazine") {
      ismagazine = true;
      return postjson.status
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: paperlist(),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Image.asset('assets/Notupdated.png'),
                ),
              ),
            );
    } else if (postjson.papers.length != 0 &&
        postjson.papers[0].type == "livetv") {
      return postjson.status
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: paperlist(),
            )
          : Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Image.asset('assets/Notupdated.png'),
                ),
              ),
            );
    } else {
      return ListView(children: <Widget>[
        postjson.mainPaper.length <= 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                        border: Border.all(color: Colors.grey)),
                    height: 270,
                    width: 400,
                    margin: EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Image.asset(
                                    'assets/Notupdated.png',
                                    width: 200,
                                  ),
                                ),
                                SizedBox(height: 120),
                                Container(
                                  height: 40,
                                  width: 395,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(
                                        'Main Edition',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  covermainimage = postjson.mainPaper[index].coverImage;

                  return GestureDetector(
                    onTap: () {
                      // Main Edition tap
                      //ismain = true;
                      loadPaper(postjson.mainPaper[index].pdf);
                    },
                    child: Card(
                      margin: EdgeInsets.all(10.0),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          postjson.mainPaper[index].coverImage.isEmpty
                              ? Container(
                                  height: 220,
                                  child: Center(
                                      child: Text(
                                    'No Image Available',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  )))
                              : Image.network(
                                  pathurl + covermainimage,
                                  fit: BoxFit.fill,
                                  height: 220,
                                  width: 390,
                                ),
                          Divider(
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                          Container(
                            height: 30,
                            width: 395,
                            child: Center(
                              child: Text(
                                'Main Edition',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
        postjson.papers.length <= 0
            ? Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Center(
                  child: Text('Districts Editions Not Updated',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(2.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: postjson.papers.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    coverimageurl = postjson.papers[index].coverImage;

                    return GestureDetector(
                      onTap: () {
                        // District Tap
                        //ismain= false;
                        districtname = postjson.papers[index].districtName;
                        downloadpath = postjson.papers[index].pdf;
                        filedownload().then((onValue){
                          loadPaper(postjson.papers[index].pdf);
                        });


                      },
                      child: new Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          borderOnForeground: true,
                          child: Column(
                            children: <Widget>[
                              coverimageurl.isEmpty
                                  ? Expanded(
                                flex: 10,
                                child: AspectRatio(
                                  aspectRatio: 2,
                                  child: Center(
                                      child: Text(
                                        'No Image Available',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      )),
                                ),
                              )
                                  : Expanded(
                                flex: 3,
                                child: AspectRatio(
                                  aspectRatio: 2.5,
                                  child: Image.network(pathurl + coverimageurl,
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 0.4,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4.0, left: 4.0, right: 4.0),
                                      child: Text(
                                        postjson.papers[index].districtName,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
              )
      ]);
      /* Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                mainpaper(),
                paperlist(),
              ],
            ),
          ),
        ],
      );*/

      /*Column(
        children: <Widget>[
          Expanded(
          flex:1,
                child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  mainpaper(),
                  paperlist(),
                ],
              ) ;
           },
          ),
        ),

        ],

      ); */

    }
  }

  textbuilder(String Txt) {
    if (Txt == "false") {
      return Text("");
    } else {
      return Text("");
    }
  }

  Widget getpaperslist() {
    return postjson.status
        ? getpaperon()
        : Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Image.asset('assets/Notupdated.png'),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            widget.subcatname,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Visibility(
              visible: _ifDateVisible,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        datepicker();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            "${selectedDate.day.toString()}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString().padLeft(2, '0')}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, left: 16.0, right: 16.0),
                    child: GestureDetector(
                        onTap: () {
                          datepicker();
                        },
                        child: Icon(Icons.date_range)),
                  ),
                ],
              ),
            )
          ],
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
          ),
        ),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : getpaperslist()),
      onWillPop: _willPopCallback,
    );
  }

  void loadPaper(String path) {
    initPlatformState();
    //mainsuccess = true;
    _finalPath = "http://telugupaper.in/news//" + path;

    if (Platform.isIOS) {
      // Open the document for iOS, no need for permission
      showViewer();
    } else {
      // Request for permissions for android before opening document
      launchWithPermission();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize(
          "Insert commercial license key here after purchase");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }

  Future<void> launchWithPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (granted(permissions[PermissionGroup.storage])) {
      showViewer();
    }
  }

  showViewer() {
    // Shows how to disable functionality. Uncomment to configure your viewer with a Config object.
    //var disabledElements = [Buttons.shareButton, Buttons.searchButton];
    //  var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
    //  var config = Config();
    //  config.disabledElements = disabledElements;
    //  config.disabledTools = disabledTools;
    //  PdftronFlutter.openDocument(_document, config: config);

    // Open document without a config file which will have all functionality enabled.
    return PdftronFlutter.openDocument(_finalPath);

  }

  bool granted(PermissionStatus status) {
    return status == PermissionStatus.granted;
  }
}
