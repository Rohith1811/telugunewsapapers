import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:share/share.dart';

void main() => runApp(youtubeapp());
class youtubeapp extends StatelessWidget {
  const youtubeapp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: youtubepage(),

    );
  }
}

class youtubepage extends StatefulWidget {
  final String videourl;
  youtubepage({Key key,this.videourl}) : super(key: key);

  @override
  _youtubepageState createState() => _youtubepageState();
}

class _youtubepageState extends State<youtubepage> {
  YoutubePlayerController _controller;
  String videoid;
  String altvideoid;
  String vidd;
  bool _isloading = true;

  @override
  void initState() {
    altvideoid = "https://www.youtube.com/watch?v=BTh71pxDESg";
    vidd = YoutubePlayer.convertUrlToId(altvideoid);
    videoid = YoutubePlayer.convertUrlToId(widget.videourl);

    _controller = YoutubePlayerController(
      initialVideoId: videoid == null ? vidd : videoid,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        isLive: true,


        hideControls: false,
        forceHideAnnotation: true,
      ),
    );
    Timer(Duration(seconds: 3), () => youtubeplayer());
    super.initState();
  }

  youtubeplayer() {
    return YoutubePlayer(
      controller: _controller,

      topActions: <Widget>[
        Spacer(),
        GestureDetector(
            onTap: () {
              Share.share(widget.videourl);
            },
            child: Icon(Icons.share, color: Colors.white,)
        )
      ],
      showVideoProgressIndicator: true,
      onReady: () {
        _isloading = false;
        print('success');
      },
      progressIndicatorColor: Colors.red,


    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Live Tv")
        ),
        body: videoid == null ? Center(
          child: Text('No updated videos', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24
          ),),
        ) : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child:youtubeplayer()


            )));
  }
}