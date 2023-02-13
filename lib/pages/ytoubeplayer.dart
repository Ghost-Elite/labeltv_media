/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../screens/dernier_video_screen.dart';
import '../screens/shimmerCardTV.dart';
import '../screens/shimmerListView.dart';
import '../screens/titre_screen.dart';
import '../utils/colors.dart';

/// Homepage
class YtoubePlayerPage extends StatefulWidget {
  int position;
  var dataUrls;
 String? apiKey,
      channelId,
      videoId,
      texte,
      lien,
      url,
      title,
      img,
      date,
      related;
  final List<YT_API>? ytResult;
  var data;
  bool enabled ;
  YtoubePlayerPage(
      {Key? key,
       this.apiKey,this.data,
      this.channelId,
      this.videoId,
       this.ytResult,
      this.texte,
      this.lien,
      this.url,
      this.title,
      this.img,
      this.date,
      this.related,this.dataUrls,
    required  this.enabled,
       List? videos,required this.position})
      : super(key: key);

  @override
  _YtoubePlayerPageState createState() => _YtoubePlayerPageState();
}

class _YtoubePlayerPageState extends State<YtoubePlayerPage> {


  PlayerState? _playerState;
  YoutubeMetaData? _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  String ?uri,tite,lien,test;
  var logger =Logger();
  bool? videoLoading;
  //var index=0;
  late int select;
  YoutubePlayerController? _controller= YoutubePlayerController(initialVideoId: '');
  var data;
  var datas;
  var dataUrl;
  VoidCallback? listeners;
  GlobalKey _betterPlayerKey = GlobalKey();

  youtubePlayer(){
    lien =widget.videoId;
    _controller = YoutubePlayerController(
      initialVideoId:
      lien!.split("=")[1],
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
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    tite = widget.title;
  }

  @override
  void initState() {
    super.initState();
    youtubePlayer();
    listeners = () {
      setState(() {
      });
    };
     select=widget.position;
  }

  void listener() {
    if (_isPlayerReady && mounted && _controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
        _videoMetaData = _controller!.metadata;
      });
    }
  }

*/
/*  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }*//*


*/
/*  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*//*


  @override
  Widget build(BuildContext context) {
    logger.i(' message 2022',Jiffy(widget.ytResult![0].publishedAt,
        "yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy a HH:mm"));
    Wakelock.enable();
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: textAppBarColor),
              onPressed: () {
                //PlayerInit(widget.dataUrls);
                //PlayerInit();
                Navigator.of(context).pop();
              }
          ),
         //iconTheme: IconThemeData(color: ColorPalette.),
          title: Text('YouTube',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),

        ),
        body: Stack(
          children: [

            Container(
              margin: EdgeInsets.only(top: 400),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: TitreScreen(
                      titre: 'Vidéos Similaires',
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(

                          (BuildContext context, int index) {
                        return widget.enabled ?
                        ShimmerListView() :
                        DernierVideoScreen(
                          image: widget.ytResult![index].thumbnail["medium"]["url"],
                          texte: widget.ytResult![index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
                          //date: '${Jiffy(widget.ytResult![index].publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
                          onTap: (){
                            setState(() {
                              uri = widget.ytResult![index].url;
                              //lien = widget.ytResult[index].url;
                              select=index;
                            });
                            _controller!.load(widget.ytResult![index].url.split("=")[1]);
                            tite = widget.ytResult![index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "");
                          },
                          color: select ==index?textPrimaryColor:Colors.transparent,
                        );
                      },
                      childCount:  widget.ytResult!.isEmpty?0:widget.ytResult!.length,
                    ),

                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 90.0),
              child: Container(
                width: double.infinity,
                height: 260,
                color: Colors.black,
                child: _controller !=null?player:Container(),
              ),
            ),
            Container(
                height: 50,
                width: double.infinity,
                margin: EdgeInsets.only(top: 350),
                color: Colors.white,
                child:  Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(

                    tite!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                    maxLines: 1,

                  ),
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
          color: Colors.transparent,
          image: widget.ytResult![index].thumbnail["medium"]["url"],
          texte: widget.ytResult![index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
          //date: '${Jiffy(widget.ytResult![index].publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
          onTap: (){
            print('hello');
          },
        );
      },
    );
  }
  Widget videoSimilaire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.2),
          //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: const Text(
                  "Vidéos Similaires",
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
              ),
              // SizedBox(width: 3,),

            ],
          ),
        ),
      ],
    );
  }

  Widget card() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: const BoxDecoration(
          color: cardColor,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "${tite}",
                style: const TextStyle(
                  color: textSecondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
