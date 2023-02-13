import 'dart:convert';
import 'package:labeltv/network/listAndroid.dart';
import 'package:labeltv/pages/tv_page_screen.dart';
import 'package:labeltv/pages/voirePlus.dart';
import 'package:labeltv/pages/youtube_lecteur_player.dart';
import 'package:labeltv/widgets/gridView_screen.dart';
import 'package:labeltv/widgets/titre_screen.dart';
import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:labeltv/widgets/dernier_video_screen.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../network/api_service.dart';
import '../network/apiitems.dart';
import '../network/channel_model.dart';
import '../network/video_model.dart';
import '../widgets/shimmerCardTV.dart';
import '../widgets/shimmerGridView.dart';
import '../utils/constants.dart';

import '../widgets/shimmerListView.dart';
import 'AllPlayListScreen.dart';
import 'SideDrawer.dart';
import 'package:loadmore/loadmore.dart';

import 'lecteur_playlist_video.dart';
import 'lecteur_youtube_video.dart';

class MobileLayoutScreen extends StatefulWidget {
  var url;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool? isLoading = false;
  var description,facebook;
  MobileLayoutScreen({Key? key,this.facebook,this.description,this.isLoading, required this.url,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult}) : super(key: key);

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>{
  var logger= Logger();
  ListAndroid? listAndroid;
  int index=0;
  bool? isSelected;
  var tvUrl;
  var select=0;

  APIItems? apiItems;
  List<APIItems> tvList = [];
  bool _enabled = true;
  var scaffold = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoadingPlaylist = true;

  Channel? _channel;
  bool _isLoading = false;
  Future<ListAndroid?> fetchListAndroid() async {
    setState(() {
      _enabled=false;
    });
    try {
      var postListUrl =
      Uri.parse(widget.url);
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        //logger.w('message',jsonDecode(response.body));
        setState(() {
          listAndroid = ListAndroid.fromJson(jsonDecode(response.body));

        });

        setState(() {
          tvUrl= listAndroid!.allitems![0].feedUrl;
        });
        //logger.w('Call Of Duty',tvUrl);
        fetchListTv(tvUrl);

      }
    } catch (error, stacktrace) {
      //internetProblem();
      setState(() {
        _enabled=true;
      });

    }


  }
  Future<APIItems?> fetchListTv(String url) async {

    try {
      var postListUrl =
      Uri.parse(tvUrl);
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        //logger.w('message',jsonDecode(response.body));
        setState(() {
          apiItems = APIItems.fromJson(jsonDecode(response.body));

        });

      setState(() {
        for (int i = 0; i < apiItems!.allitems!.length; i++) {
          apiItems?.allitems![i].isSelected = false;
        }
        isSelected= apiItems?.allitems![0].isSelected==true;
      });


    print(isSelected);


      }
    } catch (error, stacktrace) {
      //internetProblem();

    }

  }

  /*Future<void> callAPI() async {
    //print('UI callled');
    //await Jiffy.locale("fr");
    ytApi = YoutubeAPI(API_Key, maxResults: 5, type: "video");
    ytResult = await ytApi!.channel(API_CHANEL);
    setState(() {

      isLoading = true;

    });
  }
  Future<void> next()async{
    ytResult = await ytApi!.nextPage();
    //var videos = ytResult.addAll();
    setState(() {});
  }*/

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: API_CHANEL);
    setState(() {
      _channel = channel;
    });
  }
  _loadMoreVideos() async {
    _isLoading = true;

    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel!.uploadPlaylistId);
    List<Video> allVideos = _channel!.videos..addAll(moreVideos);
    setState(() {
      _channel!.videos = allVideos;
    });
    //print(allVideos.length);
    _isLoading = false;
  }
  /*Future<List<PlayListItem>?> nextPage() async{
    PlayListItemListResponse playlist = await currentPage!.nextPage();
    var videos = playlist.items.map((video){
      return video;
    }).toList();
    currentPage = playlist;
    this.videos!.addAll(videos);
    setVideos(this.videos);
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchListAndroid();

    ///ogger.w('Call Of Duty',y);
    //callAPI();
    _initChannel();


  }



  @override
  Widget build(BuildContext context) {
    //logger.w('Call Of Duty',tvUrl);
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              scaffold.currentState?.openDrawer();
            },
            child: Container(
              width: 30,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu.png')
                )
              ),
            ),
          ),
        ),
        title: Text('Accueil',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      body: RefreshIndicator(
        onRefresh: fetchListAndroid,
        color: Colors.white,
        backgroundColor: textAppBarColor,
        child: /*SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitreScreen(
                titre: 'NOS CHAINES',
              ),
              _enabled?ShimmerCardTv():makeItemTV(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *0.50,
                child: _channel != null
                    ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollDetails) {
                    if (!_isLoading && _channel!.videos.length != *//*int.parse(_channel!.videoCount!)*//*20 && scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent) {
                      _loadMoreVideos();
                      setState(() {
                        if (_isLoading) {
                          CircularProgressIndicator();
                        }
                      });
                    }

                    return false;
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 1 + _channel!.videos.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Container();
                            }
                            Video video = _channel!.videos[index - 1];
                            return  videoList(video,index);
                          },
                        ),
                      ),
                      _isLoading ?CircularProgressIndicator(color: textAppBarColor,backgroundColor: Colors.white,):SizedBox.shrink()
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
              SizedBox(
                height: 20,
              ),
              TitreScreen(
                titre: 'Emissions TV',
              ),
              SizedBox(
                height: 35,
              ),
              GridView.builder(
                  itemCount: widget.ytResultPlaylist.length > 33 ? 33 : widget.ytResultPlaylist.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 10
                  ),
                  itemBuilder: (context, position){
                    return _enabled ?
                    ShimmerGridView():
                    GridViewScreen(
                      image: widget.ytResultPlaylist[position].thumbnail["medium"]["url"],
                      text: smallSentence(widget.ytResultPlaylist[position].title),

                      onTap: (){
                        if (_enabled ==false) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AllPlayListScreen(
                                  ytResult: widget.ytResultPlaylist[position],

                                )),
                                (Route<dynamic> route) => true,);
                        }  else{

                        }
                      },
                    );
                  }
              ),


            ],
          ),
        ) */
        CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TitreScreen(
                    titre: 'NOS CHAINES',
                  ),
                ),
                SliverToBoxAdapter(
                  child: _enabled?ShimmerCardTv():makeItemTV(),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
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
                      return _enabled?
                      ShimmerListView()
                      : DernierVideoScreen(
                        color: Colors.transparent,
                        image: widget.ytResult[index].thumbnail["medium"]["url"],
                        texte: widget.ytResult[index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
                        date: '${Jiffy(widget.ytResult[index].publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
                        onTap: (){
                          print('hello');
                          if (_enabled ==false) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YtoubePlayerPage(
                                      videoId: widget.ytResult[index].url,
                                      title: widget.ytResult[index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&"),
                                      position: index,
                                      ytResult: widget.ytResult,
                                      enabled: _enabled,

                                    )

                                ),
                                    (Route<dynamic> route) => true);
                          }  else{

                          }
                        },
                      );
                    },
                    childCount:   widget.ytResult.length > 20 ? 20 : widget.ytResult.length,
                  ),

                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>VoirPlusPage(
                                enabled: _enabled,
                              ))
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Text('voir plus...',style: TextStyle(color: textColor,fontSize: 15,fontWeight: FontWeight.bold),),
                        ),
                      )
                    ],
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
                      itemCount:  widget.ytResultPlaylist.length > 33 ? 33 : widget.ytResultPlaylist.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 10
                      ),
                      itemBuilder: (context, position){
                        return _enabled?
                        ShimmerGridView():
                        GridViewScreen(
                          image: widget.ytResultPlaylist[position].thumbnail["medium"]["url"],
                          text: smallSentence(widget.ytResultPlaylist[position].title),

                          onTap: (){
                            logger.wtf('hello world',widget.ytResultPlaylist[0].id);
                            if (_enabled ==false) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YoutubeVideoPlayer(
                                      ytResult: widget.ytResultPlaylist[position],
                                      idYou: widget.ytResultPlaylist[position].id,
                                      position: position,
                                      //apikey:API_Key,

                                    )),
                                    (Route<dynamic> route) => true,);
                            }  else{

                            }
                          },
                        );
                      }
                  ),
                ),

              ],
            ),
      ),
      drawer: SideDrawer(
       url: widget.url,
        ytResultPlaylist: widget.ytResultPlaylist,
        ytResult: widget.ytResult,
        ytApiPlaylist: widget.ytApiPlaylist,
        ytApi: widget.ytApi,
        isLoading: widget.isLoading,
        description: widget.description,
        facebook: widget.facebook,
      ),
    );
  }
  Widget makeItemTV() {
    return Container(
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      // color: Colors.cyan,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: () {
              if (_enabled ==false) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>TvPageScreen(
                      data: apiItems?.allitems![position].feedUrl,
                      ytResult: widget.ytResult,
                      ytResultPlaylist: widget.ytResultPlaylist,
                      ytApi: widget.ytApi,
                      ytApiPlaylist: widget.ytApiPlaylist,
                      urlDirect: tvUrl,
                      titre: apiItems?.allitems![position].title,
                      image: apiItems?.allitems![position].logo!.trim(),
                      select: apiItems?.allitems![position].id,
                      enabled: _enabled,
                    ))
                );
              } else{
                print('error');
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
                              color: Colors.white,
                              //blurRadius: 2,
                              offset: Offset(0, 4),
                              spreadRadius: 2.3
                          ),
                        ]
                    ),
                    margin: EdgeInsets.only(left: 15,right: 10,top: 15),
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
    );
  }
  Widget videoList(Video video,int position){
    return DernierVideoScreen(
      color: Colors.transparent,
      image: video.thumbnailUrl,
      texte: video.title!.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
      date: '${Jiffy(video.publishedAt, "yyyy-MM-ddTHH").format("dd-MM-yyyy")}',
      onTap: (){
        print('hello');
        if (_enabled ==false) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>

                  YoutubeLecteurPlayer(
                    idVideo: video.id,
                    title: video.title!.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", "").replaceAll("🛑", "").replaceAll("#", ""),
                    isLoading: _isLoading,
                    channel: _channel,
                    position: position,
                  )
              ),
                  (Route<dynamic> route) => true);
        }  else{

        }
      },
    );
  }
}
