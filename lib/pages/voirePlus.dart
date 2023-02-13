import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:labeltv/pages/youtube_lecteur_player.dart';
import '../network/api_service.dart';
import '../network/channel_model.dart';
import '../network/video_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/dernier_video_screen.dart';
import 'package:jiffy/jiffy.dart';

class VoirPlusPage extends StatefulWidget {
  bool enabled = true;
  VoirPlusPage({Key? key,required this.enabled}) : super(key: key);

  @override
  State<VoirPlusPage> createState() => _VoirPlusPageState();
}

class _VoirPlusPageState extends State<VoirPlusPage> {
  Channel? _channel;
  bool _isLoading = false;
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
    print(allVideos.length);
    _isLoading = false;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initChannel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
        title: Text(' YouTube ',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: MediaQuery.of(context).size.height,
              child: _channel != null
                  ? NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!_isLoading && _channel!.videos.length != int.parse(_channel!.videoCount!) && scrollDetails.metrics.pixels == scrollDetails.metrics.maxScrollExtent) {
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
          ],
        ),
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
        if ( widget.enabled ==false) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                  /*YtoubePlayerPage(
                    videoId: widget.ytResult[index].url,
                    title: widget.ytResult[index].title.replaceAll('&quot;', '"').replaceAll("&#39;", "'").replaceAll("&amp;", "&"),
                    position: index,
                    ytResult: widget.ytResult, videos: [],
                    enabled: _enabled,
                  )*/
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
