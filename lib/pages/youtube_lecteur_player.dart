import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:jiffy/jiffy.dart';
import '../network/api_service.dart';
import '../network/channel_model.dart';
import '../network/video_model.dart';
import '../widgets/dernier_video_screen.dart';
import '../widgets/titre_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
class YoutubeLecteurPlayer extends StatefulWidget {
  var idVideo,title;
  Channel? channel;
  bool isLoading = false;
  int position;
  YoutubeLecteurPlayer({Key? key, required this.idVideo,this.title,this.channel,required this.isLoading,required this.position}) : super(key: key);

  @override
  State<YoutubeLecteurPlayer> createState() => _YoutubeLecteurPlayerState();
}

class _YoutubeLecteurPlayerState extends State<YoutubeLecteurPlayer> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  bool _isPlayerReady = false;
  var videoID,title;
  var select;
  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: API_CHANEL);
    setState(() {
      widget.channel = channel;
    });
  }
  _loadMoreVideos() async {
    widget.isLoading = true;

    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: widget.channel!.uploadPlaylistId);
    List<Video> allVideos = widget.channel!.videos..addAll(moreVideos);
    setState(() {
      widget.channel!.videos = allVideos;
    });
    print(allVideos.length);
    widget.isLoading = false;
  }
  youtubePayer(){
    videoID=widget.idVideo;
    title=widget.title;
    _controller = YoutubePlayerController(
      initialVideoId: videoID,
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.position);
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);

      },

      // get string variable

      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: textAppBarColor),
              onPressed: () {
                //PlayerInit(widget.dataUrls);
                //PlayerInit();
                Navigator.of(context).pop();
              }
          ),
          title: Text('YouTube',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),

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
            SizedBox(height: 10,),
            TitreScreen(
              titre: 'Vidéos Similaires',
            ),
            SizedBox(height: 10,),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: widget.channel != null
                  ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!widget.isLoading && widget.channel!.videos.length != /*int.parse(_channel!.videoCount!)*/40 && scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent) {
                    _loadMoreVideos();
                    setState(() {
                      if (widget.isLoading) {
                        CircularProgressIndicator(color: textAppBarColor,backgroundColor: textAppBarColor,);
                      }
                    });
                  }

                  return false;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: 1 + widget.channel!.videos.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Container();
                          }
                          Video video = widget.channel!.videos[index - 1];
                          return  videoList(video,index);
                        },
                      ),
                    ),
                    widget.isLoading ?CircularProgressIndicator(color: textAppBarColor,backgroundColor: textAppBarColor,):SizedBox.shrink()
                  ],
                ),
              )
                  : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor, // Red
                  ),
                ),
              ),
            ),
          )

          ],
        ),
      ),
    );
  }
  Widget videoList(Video video,int position){
    return DernierVideoScreen(
      color: select ==position?textPrimaryColor:Colors.transparent,
      image: video.thumbnailUrl,
      texte: video.title!.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
      date: '${Jiffy(video.publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
      onTap: (){
        setState(() {
          videoID = video.id;
          select=position;
        });
        _controller!.load(video.id!);
        title = video.title!.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "");
      },
    );
  }
}
