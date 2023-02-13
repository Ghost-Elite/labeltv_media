import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:jiffy/jiffy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/network/apiitems.dart';
import 'package:labeltv/widgets/dernier_video_screen.dart';
import 'package:labeltv/widgets/gridView_screen.dart';
import 'package:labeltv/widgets/shimmerCardTV.dart';
import 'package:labeltv/widgets/shimmerListView.dart';
import 'package:labeltv/widgets/titre_screen.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:better_player/better_player.dart';
import 'package:labeltv/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:logger/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wakelock/wakelock.dart';
import '../network/apilive.dart';
import '../widgets/shimmerGridView.dart';
import 'AllPlayListScreen.dart';
import 'lecteur_youtube_video.dart';

class TvPageScreen extends StatefulWidget {
  var data,urlDirect,titre,image;
  var select;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool enabled = true;
  TvPageScreen({Key? key,required this.enabled,this.select,this.image,this.titre,this.urlDirect,this.data,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult}) : super(key: key);

  @override
  State<TvPageScreen> createState() => _TvPageScreenState();
}

class _TvPageScreenState extends State<TvPageScreen> with WidgetsBindingObserver{
  BetterPlayerController? betterPlayerController;
  bool?  videoLoading;
  var dataUrl,apiUrl,api,direcUrl;
  var logger=Logger();
  List datas=[];
  var items;
  bool? linkTv;
  APIItems? apiItems;
  ApiLive? apiLive;
  var index=0;
  var select=0;
  bool enabled = true;
  bool isPlayer=false;
  bool isMuet=false;
  bool isPlayingMiddleIcon=false;
  bool isFullScreen=false;
  bool controlsNotVisible = true;
  bool? autoPlay;
  bool? autoPause;
  String tvIcon = "";
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    fit: BoxFit.cover,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    //autoDispose: true,
    controlsConfiguration:  BetterPlayerControlsConfiguration(
      loadingWidget: SizedBox(
          width: 100,
          child: Lottie.asset(
            kLoadings,
            width: 60,
            repeat: true,
            reverse: true,
          )
      ),
      iconsColor: Colors.white,
      //controlBarColor: colorPrimary,
      controlBarColor: Colors.transparent,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enablePip: true,
      enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: Colors.green,
      enableSkips: false,
      overflowMenuIconsColor: Colors.white,

    ),
  );
  Future<APIItems?> fetchListTv() async {
      setState(() {
        enabled=false;
      });
    try {
      var postListUrl =
      Uri.parse(widget.urlDirect);
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        //logger.w('message',jsonDecode(response.body));
        setState(() {
          apiItems = APIItems.fromJson(jsonDecode(response.body));

        });
       /* setState(() {
          for(var i= 0;i<apiItems!.allitems!.length;i++){
            apiItems!.allitems![i].isSelected =false;
          }
          apiItems!.allitems![0].isSelected =true;
        });


        print(apiItems!.allitems![0].type);*/


      }
    } catch (error, stacktrace) {
      //internetProblem();
      setState(() {
        enabled=true;
      });


    }


  }
  Future<ApiLive?> getApiUrl() async {

    try {
      var postListUrl =
      Uri.parse(dataUrl);
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        //logger.w('message',jsonDecode(response.body));
        setState(() {
          apiLive = ApiLive.fromJson(jsonDecode(response.body));

        });
        setState(() {
          if (Platform.isIOS) {
            direcUrl=apiLive!.directUrl.toString();
          }  else{
            direcUrl=apiLive!.androidUrl.toString();
          }

        });

        /*for(var i= 0;i<apiItems!.allitems!.length;i++){
          if(apiItems!.allitems![i].type == 'TV'){
            linkTV=apiItems!.allitems![i].feedUrl;
          }

        }*/
        //print(apiLive!.directUrl);

        PlayerInit(direcUrl);


      }
    } catch (error, stacktrace) {
      //internetProblem();


    }


  }
  Future<void> retryMethode() async {
    // Create an HttpClient.
    final client = HttpClient();

    try {
      // Get statusCode by retrying a function
      final statusCode = await retry(
            () async {
          // Make a HTTP request and return the status code.
          final request = await client
              .getUrl(Uri.parse('https://www.google.com'))
              .timeout(Duration(seconds: 5));
          final response = await request.close().timeout(Duration(seconds: 5));
          await response.drain();
          return response.statusCode;
        },
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      // Print result from status code
      if (statusCode == 200) {
        logger.i('google.com is running');
        fetchListTv();
        getApiUrl();
      } else {
        logger.i('google.com is not availble...');
      }
    } finally {
      // Always close an HttpClient from dart:io, to close TCP connections in the
      // connection pool. Many servers has keep-alive to reduce round-trip time
      // for additional requests and avoid that clients run out of port and
      // end up in WAIT_TIME unpleasantries...
      client.close();
    }
  }
  void PlayerInit(String url){
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      liveStream: true,

    );

    //betterPlayerController.setupDataSource(dataSource);
    //betterPlayerController?.setBetterPlayerGlobalKey(_betterPlayerKey);
    betterPlayerController?.setupDataSource(dataSource)
        .then((response) {
      //s.logger.i(' Ghost-Elite ',dataSource);
      videoLoading = false;
    })
        .catchError((error) async {
      // Source did not load, url might be invalid
      inspect(error);
    });
    betterPlayerController?.addEventsListener((event) {
      if(betterPlayerController!.isFullScreen){
        SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.landscapeRight
            ]
        );
      }else{
        SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp,
            ]
        );
      }
    });
    betterPlayerController!.setControlsEnabled(false);
    betterPlayerController!.addEventsListener((event){
      print("Better player event: ${event.betterPlayerEventType}");
      if(event.betterPlayerEventType ==BetterPlayerEventType.hideFullscreen){
        betterPlayerController!.setControlsEnabled( betterPlayerController!.isFullScreen?true:
        false);
      }
    });
  }
  bool? force;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dataUrl=widget.data;

      //PlayerInit(api['direct_url']);
    });
    //print(apiLive!.directUrl);
    //PlayerInit(apiLive!.directUrl.toString());
    //getApiUrl();
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration)..addEventsListener((error) => {
      if(error.betterPlayerEventType.index==9){
        logger.i(error.betterPlayerEventType.index,"index event"),
        retryMethode(),
        betterPlayerController!.retryDataSource()
      }

    });


    retryMethode();
    ///startTime();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //betterPlayerController!.dispose();
    /*betterPlayerController!.addEventsListener((event) {
      if(betterPlayerController!.isFullScreen){
        SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp
            ]
        );
      }
    });*/
  }
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    print('##############');
    print(dataUrl);
    print('##############');
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: textAppBarColor,), onPressed: () {
            Navigator.of(context).pop(true);
        },
        ),
        title: Text(widget.titre,style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          player(),
          /*Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            margin: EdgeInsets.only(top: 220),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Container(
                        width: 90,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.image),
                              fit: BoxFit.contain
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      child: Container(
                        child: Text('EN COURS - Infos ${widget.titre}',style: TextStyle(color: textColor,fontSize: 14,fontFamily: 'Inter'),),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: dividerColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,

                    child: Text('Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation',style: TextStyle(color: textSecondaryColor),),
                  ),
                )
              ],
            ),
          ),*/
          Container(
              height: 104,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 49,
                      color: tvColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              isPlayingMiddleIcon
                                  ? Icons.play_arrow_outlined
                                  : Icons.pause,
                              color: Colors.white,size: 31,
                            ),
                            onPressed: () {
                              if (isPlayingMiddleIcon == true) {
                                betterPlayerController!.play();
                              } else {
                                betterPlayerController!.pause();
                              }
                              setState(() {
                                isPlayingMiddleIcon = !isPlayingMiddleIcon;
                              });
                            },
                          ),

                          SizedBox(width: 230,),
                          IconButton(
                            icon: Icon(
                                isMuet
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: Colors.white,size: 31
                            ),
                            onPressed: () {
                              if (isMuet == true) {
                                betterPlayerController!.setVolume(1);
                              } else {
                                betterPlayerController!.setVolume(0);
                              }
                              setState(() {
                                setState(() {
                                  isMuet = !isMuet;
                                });
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                                Icons.fullscreen_rounded,
                                color: Colors.white,size: 31
                            ),
                            onPressed: () {
                              betterPlayerController
                              !.setControlsEnabled(true);
                              if (!isFullScreen == true) {
                                betterPlayerController
                                !.enterFullScreen();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 40,
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Colors.white,
                            border: Border.all(color: Colors.white)
                        ),
                        margin: const EdgeInsets.all(5),
                        child: tvIcon == null
                            ? const Icon(
                          Icons.live_tv,
                          color: Colors.cyan,
                          size: 35,
                        )
                            : CachedNetworkImage(
                          imageUrl: widget.image,
                          height: 30,
                          width: 30,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Image.asset(
                            "assets/images/ic_launcher.png",
                            fit: BoxFit.contain,
                            height: 30,
                            width: 30,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/ic_launcher.png",
                            fit: BoxFit.contain,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Vous suivez ${widget.titre} en Direct",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textTVColor),
                      ),
                    ],
                  ),
                  /*Divider(color: dividerColor,height: 1,endIndent: 10,indent: 10,),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: Text(
                          smallSentences()
                          ,style: TextStyle(color: Colors.black,fontSize: 14,fontFamily: 'Inter'),
                          maxLines: 2,
                        textAlign: TextAlign.start,
                        ),
                    ),
                  )*/
                ],
              )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchListTv ,
              color: Colors.white,
              backgroundColor: textAppBarColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Text(
                            'NOS CHAINES',
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: enabled?ShimmerCardTv(): makeItemTV() ,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Text(
                            'REVOIR TV',
                            style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )

                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(

                            (BuildContext context, int index) {
                          return enabled?
                                ShimmerListView() :
                                DernierVideoScreen(
                                  color: Colors.transparent,
                                  image: widget.ytResult[index].thumbnail["medium"]["url"],
                                  texte: widget.ytResult[index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
                                 date: '${Jiffy(widget.ytResult[index].publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
                                  onTap: (){
                                    print('hello');

                                    if (enabled == false) {
                                      betterPlayerController!.pause();
                                      setState(() {
                                        isPlayingMiddleIcon = !isPlayingMiddleIcon;
                                      });
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => YtoubePlayerPage(
                                                videoId: widget.ytResult[index].url,
                                                title: widget.ytResult[index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&"),
                                                position: index,
                                                ytResult: widget.ytResult,
                                                enabled: enabled,

                                              )),
                                              (Route<dynamic> route) => true);
                                    }  else{

                                    }

                                  },
                                );
                        },
                        childCount:  widget.ytResult.length > 20 ? 20 :widget.ytResult.length,
                      ),

                    ),

                    SliverToBoxAdapter(
                      child: TitreScreen(
                        titre: 'Emissions TV',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 35,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: GridView.builder(
                          itemCount: widget.ytResultPlaylist.isEmpty?0:widget.ytResultPlaylist.length,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              //childAspectRatio: 4 / 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10),
                          itemBuilder: (context, position){
                            return enabled?ShimmerGridView(): GridViewScreen(
                              image: widget.ytResultPlaylist[position].thumbnail["medium"]["url"],
                              text: smallSentence(widget.ytResultPlaylist[position].title),
                              onTap: (){
                                print('hello world');
                                if (enabled ==false) {
                                  setState(() {
                                    isPlayingMiddleIcon = !isPlayingMiddleIcon;
                                  });
                                  betterPlayerController!.pause();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => YoutubeVideoPlayer(
                                          ytResult: widget.ytResultPlaylist![position],
                                          idYou: widget.ytResultPlaylist![position].id,
                                          position: position,
                                          //apikey:API_Key,

                                        )),
                                        (Route<dynamic> route) => true,);
                                }else{

                                }
                              },
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
  Widget player() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 230,
        child: betterPlayerController != null
            ? AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: betterPlayerController!,
            //key: _betterPlayerKey,
          ),
        )
            : SizedBox.shrink(),
    );
  }
  Widget makeItemTV() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 130,
        child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: () {
                if (!enabled) {
                  betterPlayerController!.pause();
                  setState(() {
                    dataUrl=apiItems!.allitems![position].feedUrl;
                    widget.image=apiItems!.allitems![position].logo;
                    widget.titre=apiItems!.allitems![position].title;
                    getApiUrl();
                    widget.select=apiItems?.allitems![position].id;

                    isPlayingMiddleIcon = false;
                    isMuet = false;
                  });

                }  else{

                }
              },
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: 94,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: widget.select==apiItems?.allitems![position].id?textPrimaryColor:Colors.transparent,
                                //blurRadius: 2,
                                offset: Offset(0, 1),
                                spreadRadius: 2.3
                            ),
                          ]
                      ),
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              height: 94,
                              child: CachedNetworkImage(
                                imageUrl: apiItems!.allitems![position].logo!.trim(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Image.asset(
                                      "assets/images/cadre.png",
                                      width: MediaQuery.of(context).size.width * 0.40,height: 94,fit: BoxFit.cover,
                                    ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                      "assets/images/cadre.png",width: MediaQuery.of(context).size.width,height: 94,fit: BoxFit.cover,
                                    ),
                                width: MediaQuery.of(context).size.width * 0.40,
                                height: 94,
                              ),
                            ),
                          ),

                        ],
                      )),

                ],
              ),
            );
          },
          itemCount: apiItems ==null?0:apiItems!.allitems!.length,
        ),
      ),
    );
  }
}
