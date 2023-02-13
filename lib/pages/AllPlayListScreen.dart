import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/pages/youtube_playerList.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../network/ChannelInfo.dart';
import '../network/VideosList.dart';
import '../utils/services.dart';
import '../widgets/titre_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  int position;
  YT_APIPlaylist? ytResult;
  var idYou;
  YoutubeVideoPlayer({Key? key,this.ytResult,this.idYou,required this.position}) : super(key: key);

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  List<PlayListItem> videos = [];
  VideoListResponse? videoListResponse;
  PlayListItemListResponse? currentPage;
  ChannelInfo? _channelInfo;
  VideosList? _videosList;
  Item? _item;
  bool? _loading;
  String? _playListId;
  String? _nextPageToken;
  String videoIds ='';

  getChannelInfo() async {
    _channelInfo = await Services.getChannelInfo();
    _item = _channelInfo!.items![0];
    widget.idYou = _item!.contentDetails!.relatedPlaylists!.uploads;
    await _loadVideos();
    setState(() {
      _loading = false;
    });
  }
  _loadVideos() async {
    VideosList tempVideosList = await Services.getVideosList(
      playListId: widget.idYou,
      pageToken: _nextPageToken!,
    );
    _nextPageToken = tempVideosList.nextPageToken;
    _videosList!.videos!.addAll(tempVideosList.videos!);
    setState(() {});
  }
  String title ='';
  var logger = Logger();
  var urlIds;
  Future<List<PlayListItem>?> getMusic() async{
    YoutubeAPIv3 api = new YoutubeAPIv3(API_Key);
    PlayListItemListResponse playlist = await api.playListItems(playlistId : '${widget.ytResult!.id}',maxResults:10,part:Parts.snippet);
    var videos = playlist.items.map((video){
      return video;
    }).toList();

    currentPage = playlist;

    this.videos.addAll(videos);
    setVideos(this.videos);
      print(videos.length);
      setState(() {
        videoIds =videos[0].snippet.resourceId.videoId;
        title=videos[0].snippet.title;
      });
      setState(() {
        _loading ==false;
      });
      //navigationPage(videoIds);


  }

  setVideos(videos){
    setState(() {
      this.videos = videos;
      //print(videos);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMusic();
    _loading = true;
    _nextPageToken = '';
    print(videoIds);
    _videosList = VideosList();
    _videosList!.videos = [];

    getChannelInfo();
  }

  @override
  Widget build(BuildContext context) {
    //print(videoIds);
    return Scaffold(
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
      body: _loading! ? Center(child: CircularProgressIndicator(color: textAppBarColor,backgroundColor: textAppBarColor,)) : AllPlayListScreen(
        data: videoIds,
        ytResult: widget.ytResult,
        title: title,
        videos: videos,
        loading: _loading,
        position: widget.position,
      ),
    );
  }

}



class AllPlayListScreen extends StatefulWidget {
  YT_APIPlaylist? ytResult;
  var data,idUrl,title;
  var  videos ;
  bool? loading;
  int position;
  AllPlayListScreen({this.ytResult,this.data, this.idUrl,this.title, required this.videos,this.loading,required this.position});

  @override
  _AllPlayListState createState() => _AllPlayListState();
}

class _AllPlayListState extends State<AllPlayListScreen> {
  bool isLoading = true;
  var data;
  var logger = Logger();
  YoutubePlayerController? _controller = new YoutubePlayerController(initialVideoId: '');
  ///YoutubePlayerController? _controller2 = new YoutubePlayerController(initialVideoId: '');
  PlayerState? _playerState;
  bool _isPlayerReady = false;
  String videoID = '';
  String title ='';
  String url='';
  String vid='';
  var select;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<YT_APIPlaylist> ytResultPlaylist = [];
  String videoIds ='';
  var urlIds;
  List  test  = [];
  youtubePalyers(String url){
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
    super.initState();
    //getData();

    //logger.wtf(widget.videos![0].snippet.resourceId.videoId);
    //getYoutubeid();
    test = widget.videos;
    /*if (widget.loading==true) {
      print(widget.data);
      youtubePalyers(widget.data);
    }  else{



    }*/
    if (test.length > 0) {
      youtubePalyers(test[0].snippet.resourceId.videoId.toString());
    }

    }

  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        _playerState = _controller!.value.playerState;
      });
      SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp
          ]
      );
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller!.pause();
    super.deactivate();
    SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeRight
        ]
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return test.length == 0
        ? Scaffold(
      body: Center(child: Text('pas de video disponible ',style: TextStyle(color: textAppBarColor),
        ),
      ),
    )
        : YoutubePlayerBuilder(
          onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        onEnterFullScreen: (){

        },
      player: YoutubePlayer(
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
        body: isLoading==false

            ?CircularProgressIndicator(color: textAppBarColor,)

            : Column(
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
                widget.title,
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
            SizedBox(height: 15,),
            //SizedBox(height: 20,),
            Expanded(child:  gridView()),

          ],
        ),
      ),
    );
  }
  Widget makeGridView(){

    return  Container(
      //padding: const EdgeInsets.fromLTRB(0, 95.0, 0, 0),
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2 ,
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: List.generate(data==null?0:data["items"].length,(index){
            //print(data["items"]["snippet"][index]["thumbnails"]["maxres"]["url"]);
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => youtubeplayerListPage(
                            url: data["items"][index]["snippet"]["resourceId"]["videoId"],
                            titre: data["items"][index]["snippet"]["title"],
                            image: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],
                            desc: data["items"][index]["snippet"]["title"],
                            //title: data["items"][index]["snippet"]["title"],

                            data: data,
                          ),
                        )
                    );
                  },
                  child: Stack(
                    children: [

                      GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 139,
                            child: CachedNetworkImage(
                              imageUrl: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],width: 100,height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/cadre.png",width: 150,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/cadre.png",width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: IconButton(
                          icon: Icon(
                            Icons.play_circle_fill,
                            size: 37,
                            color: textSecondaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => youtubeplayerListPage(
                                    url: data["items"][index]["snippet"]["resourceId"]["videoId"],
                                    titre: data["items"][index]["snippet"]["title"],
                                    image: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],
                                    desc: data["items"][index]["snippet"]["title"].replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", ""),
                                    //title: data["items"][index]["snippet"]["title"],

                                    data: data,
                                  ),
                                )
                            );
                          },
                        ),
                      ),


                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,

                      child: Text("${data["items"][index]["snippet"]["title"]}",
                        style: TextStyle(fontSize: 13,color: textColor,fontWeight: FontWeight.bold,fontFamily: 'Inter',),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),

              ],
            );
          }),
        )
    );

  }
  Widget gridView(){
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      itemCount: widget.videos==null?0:widget.videos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 3 / 4,
          mainAxisExtent: 230,
          crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 120,
            height: 190,

            child: Column(
              children: [
                Container(
                  height: 150,
                  child: Stack(
                    children: [

                      GestureDetector(
                        onTap: (){
                          log(videoIds);
                          setState(() {
                            videoIds =widget.videos[index].snippet.resourceId.videoId;
                            widget.title = widget.videos[index].snippet.title;

                          });
                          _controller!.load(videoIds);
                          widget.title = widget.videos[index].snippet.title;
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: CachedNetworkImage(
                              imageUrl: widget.videos[index].snippet.thumbnails.medium.url,width: 100,height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/cadre.png",width: 150,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/cadre.png",width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: IconButton(
                          icon: Icon(
                            Icons.play_circle_fill,
                            size: 37,
                            color: textSecondaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => youtubeplayerListPage(
                                    url: data["items"][index]["snippet"]["resourceId"]["videoId"],
                                    titre: data["items"][index]["snippet"]["title"],
                                    image: data["items"][index]["snippet"]["thumbnails"]["medium"]["url"],
                                    desc: data["items"][index]["snippet"]["title"].replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", ""),
                                    //title: data["items"][index]["snippet"]["title"],

                                    data: data,
                                  ),
                                )
                            );
                          },
                        ),
                      ),


                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text("${widget.videos[index].snippet.title}",
                    style: TextStyle(fontSize: 13,color: textColor,fontWeight: FontWeight.bold,fontFamily: 'Inter',),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
