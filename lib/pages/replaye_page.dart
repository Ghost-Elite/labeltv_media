import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/gridView_screen.dart';
import '../widgets/shimmerGridView.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'AllPlayListScreen.dart';
class ReplayerPage extends StatefulWidget {
  YoutubeAPI? ytApiPlaylist;
  List<YT_API>? ytResult = [];
  List<YT_APIPlaylist>? ytResultPlaylist = [];
  bool enable;
  ReplayerPage({Key? key,required this.enable,required this.ytApiPlaylist,required this.ytResult,required this.ytResultPlaylist,}) : super(key: key);

  @override
  State<ReplayerPage> createState() => _ReplayerPageState();
}

class _ReplayerPageState extends State<ReplayerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: textAppBarColor),
            onPressed: () {
              Navigator.of(context).pop();
            }
        ),
        title: const Text('Replay',style: TextStyle(color: textAppBarColor,fontSize: 24,fontWeight: FontWeight.bold),),

      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(
              child: CustomScrollView(
                slivers: [

                  SliverToBoxAdapter(
                    child: GridView.builder(
                        itemCount: widget.ytResultPlaylist!.isEmpty?0:widget.ytResultPlaylist!.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10
                        ),
                        itemBuilder: (context, position){
                          return widget.enable?
                          ShimmerGridView():
                          GridViewScreen(
                            image: widget.ytResultPlaylist![position].thumbnail["medium"]["url"],
                            text:smallSentence(widget.ytResultPlaylist![position].title) ,
                            onTap: (){
                              print('hello world');
                              if (widget.enable ==false) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => YoutubeVideoPlayer(
                                        ytResult: widget.ytResultPlaylist![position],
                                        idYou: widget.ytResultPlaylist![position].id,
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
            )
          ],
        ),
      ),
    );
  }
  Widget gidViewVideo(){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          //childAspectRatio: 4 / 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 10),
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

                  )),
                  (Route<dynamic> route) => true,);
          },
          child: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color:Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0,
                            3), // changes position of shadow
                      ),
                    ],
                  ),
                  //margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                height: 125,
                                width: MediaQuery.of(context).size.width,
                                imageUrl:  widget.ytResultPlaylist![position].thumbnail["medium"]["url"],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/cadre.png",
                                  fit: BoxFit.cover,
                                  height: 110,
                                  width: 110,
                                  //color: colorPrimary,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/cadre.png",
                                  fit: BoxFit.cover,
                                  height: 110,
                                  width: 110,
                                  //color: colorPrimary,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Flexible(
                          child: Container(
                            child: Container(
                              alignment: Alignment.center,
                              //height: 70,
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                widget.ytResultPlaylist![position].title,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Inter',color: textColor,fontSize: 13,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

            ],
          ),
        );
      },
      itemCount: widget.ytResultPlaylist==null?0:widget.ytResultPlaylist!.length,
    );
  }
}
