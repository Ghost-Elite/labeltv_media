import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:labeltv/pages/youtubeEmisions.dart';
import 'package:youtube_api/youtube_api.dart';
import '../widgets/shimmerGridView.dart';
import '../widgets/shimmerListView.dart';
import '../utils/colors.dart';
import 'AllPlayListScreen.dart';
import 'YoutubeChannelScreen.dart';
import 'lecteur_youtube_video.dart';

// ignore: must_be_immutable
class YoutubeVideoPlayList extends StatefulWidget {
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API>? ytResult = [];
  List<YT_APIPlaylist>? ytResultPlaylist = [];
  bool? enabled;
  YoutubeVideoPlayList({Key? key,this.ytApi,this.ytApiPlaylist, this.ytResultPlaylist, this.ytResult,this.enabled })
      : super(key: key);

  @override
  _YoutubeVideoPlayListState createState() => new _YoutubeVideoPlayListState();
}

class _YoutubeVideoPlayListState extends State<YoutubeVideoPlayList>
    with AutomaticKeepAliveClientMixin<YoutubeVideoPlayList> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();




  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());

    //print('hello');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textAppBarColor,),
        title: Text('YouTube',style: TextStyle(color: textAppBarColor,fontWeight: FontWeight.bold)),

      ),
      body: Container(
          child: Stack(
            children: [
              /*traitWidget(),*/

              ConstrainedBox(
                constraints: BoxConstraints(),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            child: Text(
                              "Nouveautés",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: textAppBarColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                          //(height: 20,),
                          Container(child: makeItemVideos()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(right: 10),
                                    child:  Text(
                                      "Voir Plus...",
                                      style: TextStyle(color: textAppBarColor,fontWeight: FontWeight.bold),
                                    )
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            YoutubeChannelScreen(
                                             ytResultPlaylist: widget.ytResultPlaylist,
                                              ytResult: widget.ytResult,

                                            ),
                                      ));

                                },
                              )
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                            child:  Text(
                              "Nos Playlists",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: textAppBarColor,fontWeight: FontWeight.bold),
                            ),
                          ),
                          /*traitWidget(),*/

                          makeItemEmissions(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "Voir Plus...",
                                      style: TextStyle(color: textAppBarColor,fontWeight: FontWeight.bold),
                                    )),
                                onTap: () {
                                  Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeEmisionPage(
                                              ytResultPlaylist: widget.ytResultPlaylist,
                                            )
                                        ),
                                      );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget makeGridView() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 95.0, 0, 0),
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          crossAxisSpacing: 8,
          mainAxisSpacing: 4,
          children: List.generate(
              widget.ytResultPlaylist == null ? 0 :  widget.ytResultPlaylist!.length, (index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => YoutubeVideoPlayer(
                            ytResult: widget.ytResultPlaylist![index],
                            idYou: widget.ytResultPlaylist![index].id,
                            position: index,
                            //apikey:API_Key,

                          ),
                        ),
                        (Route<dynamic> route) => true);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl:  widget.ytResultPlaylist![index].thumbnail['high']
                            ['url'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          "assets/images/cadre.png",
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/cadre.png",
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Text(
                      "${ widget.ytResultPlaylist![index].title}",
                      style: TextStyle(color: textColor,fontWeight: FontWeight.w600,fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }

  Widget makeItemVideos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
      itemBuilder: (context, position) {
        return widget.enabled!?
        ShimmerGridView() : Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => YtoubePlayerPage(
                          videoId:  widget.ytResult![position].url,
                          title:  widget.ytResult![position].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", ""),
                          ytResult:  widget.ytResult!,
                          enabled: widget.enabled!,
                          position: position,
                        )),
                        (Route<dynamic> route) => true);
              },
              child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              height: 130,
                              width: MediaQuery.of(context).size.width,
                              imageUrl:  widget.ytResult![position].thumbnail['medium']
                              ['url'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/cadre.png",
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                                //color: colorPrimary,
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    "assets/images/cadre.png",
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                    //color: colorPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                widget.ytResult![position].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", ""),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: textColor,fontSize: 13,fontWeight: FontWeight.bold,fontFamily: 'Inter'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Positioned(
              bottom: 70,
              right: 8,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => YtoubePlayerPage(
                              videoId:  widget.ytResult![position].url,
                              title:  widget.ytResult![position].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&").replaceAll("//", "").replaceAll("🔴", ""),
                              ytResult:  widget.ytResult!,
                              enabled: widget.enabled!,
                              position: position,
                            )),
                            (Route<dynamic> route) => false);
                  },
                  child: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      size: 42,
                      color: textSecondaryColor,
                    ), onPressed: () {  },
                  ),
                ),
              ),
            )
          ],
        );
      },
      itemCount:  widget.ytResult!.length > 8 ? 8 :  widget.ytResult!.length,
    );
  }


  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => YoutubeVideoPlayer(
                    ytResult: widget.ytResultPlaylist![position],
                    idYou: widget.ytResultPlaylist![position].id,
                    position: position,
                    //apikey:API_Key,

                  ),
                ),
                (Route<dynamic> route) => true);
          },
          child: widget.enabled!?
          ShimmerListView():Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      //alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipRRect(
                            //borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:  widget.ytResultPlaylist![position]
                                  .thumbnail["medium"]["url"],
                              fit: BoxFit.cover,
                              width: 150,
                              height: 110,
                              placeholder: (context, url) => Image.asset(
                                "assets/images/cadre.png",fit: BoxFit.cover
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/cadre.png",fit: BoxFit.cover
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                widget.ytResultPlaylist![position].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: textColor,fontFamily: 'Inter',fontSize: 13,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.playlist_play,
                                  size: 25,
                                  color: textAppBarColor,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
      itemCount:  widget.ytResultPlaylist == null ? 0 :  widget.ytResultPlaylist!.length,
    );
  }

}
