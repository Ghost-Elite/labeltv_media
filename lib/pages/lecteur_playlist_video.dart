import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/titre_screen.dart';
class LecteurPlaylistVideo extends StatefulWidget {
  YT_APIPlaylist? youtubePlayList;
  LecteurPlaylistVideo({Key? key,this.youtubePlayList}) : super(key: key);

  @override
  State<LecteurPlaylistVideo> createState() => _LecteurPlaylistVideoState();
}

class _LecteurPlaylistVideoState extends State<LecteurPlaylistVideo> {
  YoutubePlayerController? _controller = new YoutubePlayerController(initialVideoId: '');
  //YoutubePlayerController? _controller2 = new YoutubePlayerController(initialVideoId: '');
  String videoIds ='';
  String title ='';
  String id ='';
  bool _isPlayerReady = false;
  PlayerState? _playerState;
  List<PlayListItem> videos = [];
  PlayListItemListResponse? currentPage;
  Future<List<PlayListItem>?> getMusic() async{
    YoutubeAPIv3 api = new YoutubeAPIv3(API_Key);

    PlayListItemListResponse playlist = await api.playListItems(playlistId : '${widget.youtubePlayList!.id}',maxResults:5,part:Parts.snippet);
    var videos = playlist.items.map((video){
      return video;
    }).toList();
    currentPage = playlist;
    this.videos.addAll(videos);
   // setVideos(this.videos);
    setState(() {
      videoIds =videos[0].snippet.resourceId.videoId;
      title=videos[0].snippet.title;
    });

    //print(videoIds);
    id = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=${videoIds}")!;
    print(videoIds);
    youtubePlayer(id);
    /*if (_controller!.value.isPlaying== false) {
      //youtubePayer();
      print('ghost');
    }  else{
      _controller = YoutubePlayerController(
        initialVideoId: 'vgGzUO-ezjg',
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
    }*/
  }
  youtubePlayer(String url){
    _controller = YoutubePlayerController(
      initialVideoId: url,
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
    getMusic();
    //print(videoIds);
    setState(() {
      id =videoIds;
    });
    print(id);


  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    //print(videoIds);
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player:  YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        onReady: (){
          _controller!.addListener(() {
            _isPlayerReady=true;
          });
        },
      ),
      builder: (context, player) =>  Scaffold(
        // extendBodyBehindAppBar: true,
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
          title: Text('Playlist',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),

        ),
        body:  Column(
          children: [
            Visibility(
              visible: _controller!.value.isPlaying ==false,
              child: Container(
                width: double.infinity,
                height: 260,
                color: Colors.black,
                child: _controller!=null?player:Container(),
              ),
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


          ],
        ),
      ),
    );
  }
}
