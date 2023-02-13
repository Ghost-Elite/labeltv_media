import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:jiffy/jiffy.dart';
import '../widgets/dernier_video_screen.dart';
import '../widgets/titre_screen.dart';
import '../utils/colors.dart';
import 'package:wakelock/wakelock.dart';
class YtoubePlayerPage extends StatefulWidget {
  int position;
  String? lien, url, title,videoId;
  bool? enabled ;
  final List<YT_API>? ytResult;
  YtoubePlayerPage({Key? key,this.ytResult,required this.position,this.title,this.lien,this.url,this.enabled,this.videoId}) : super(key: key);

  @override
  State<YtoubePlayerPage> createState() => _YtoubePlayerPageState();
}

class _YtoubePlayerPageState extends State<YtoubePlayerPage> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  var videoID,title;
  var select;

  youtubePayer(){
    videoID=widget.videoId;
    title=widget.title;
    _controller = YoutubePlayerController(
      initialVideoId: videoID.split("=")[1],
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _playerState = PlayerState.unknown;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    youtubePayer();
    select =widget.position;
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }



  @override
  Widget build(BuildContext context) {
    print(widget.position);
    Wakelock.enable();
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        //SystemChrome.setPreferredOrientations(DeviceOrientation.values);

      },
      /*onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      },*/
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: appBarColor,
          iconTheme: IconThemeData(color: textAppBarColor),
          title: const Text('YouTube',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.black,
              child: _controller !=null?player:Container(),
            ),
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              child:  Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                  maxLines: 1,

                ),
              ),
            ),
            TitreScreen(
              titre: 'Vidéos Similaires',
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: listVideos(),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget listVideos(){
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: widget.ytResult!.length,
      itemBuilder: (BuildContext context, int index) {
        return DernierVideoScreen(
          color: select ==index?textPrimaryColor:Colors.transparent,
          image: widget.ytResult![index].thumbnail["medium"]["url"],
          texte: widget.ytResult![index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
          date: '${Jiffy(widget.ytResult![index].publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
          onTap: (){
            setState(() {
              videoID = widget.ytResult![index].url;
              //lien = widget.ytResult[index].url;
              select=index;
            });
            _controller!.load(widget.ytResult![index].url.split("=")[1]);
            title = widget.ytResult![index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "");
          },
        );
      },
    );
  }
}