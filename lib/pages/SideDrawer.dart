import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labeltv/pages/apropos.dart';
import 'package:labeltv/pages/policy.dart';
import 'package:labeltv/pages/replaye_page.dart';
import 'package:labeltv/pages/tv_page_screen.dart';
import 'package:labeltv/pages/youtubeVideoPlaylist.dart';
import 'package:youtube_api/youtube_api.dart';
import '../network/apiitems.dart';
import '../network/listAndroid.dart';
import '../utils/colors.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
class SideDrawer extends StatefulWidget {
  var url;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool? isLoading = false;
  var description,facebook;
  SideDrawer({Key? key,this.facebook,this.description,this.isLoading, required this.url,this.ytApiPlaylist,this.ytApi,required this.ytResultPlaylist,required this.ytResult}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  var logger= Logger();
  ListAndroid? listAndroid;
  int index=0;
  int? test;
  bool? isSelected=false;
  var tvUrl;
  var select;
  APIItems? apiItems;
  List<APIItems> tvList = [];
  bool _enabled = true;
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

        });

        /*for(var i= 0;i<apiItems!.allitems!.length;i++){
          if(apiItems!.allitems![i].type == 'TV'){
            linkTV=apiItems!.allitems![i].feedUrl;
          }

        }*/


      }
    } catch (error, stacktrace) {
      //internetProblem();

    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchListAndroid();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width* 0.90,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      /*decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/drawer.png'),
              fit: BoxFit.cover
          )
      ),*/
      child: Column(
        children: [
          DrawerHeader(
              child: Container(
                width: MediaQuery.of(context).size.width *0.60,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/ic_launcher.png'),

                    )
                ),
              )
          ),
          ListTile(

            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Text(
                'LABEL TV',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              if (_enabled ==false) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>TvPageScreen(
                      data: apiItems?.allitems![0].feedUrl,
                      ytResult: widget.ytResult,
                      ytResultPlaylist: widget.ytResultPlaylist,
                      ytApi: widget.ytApi,
                      ytApiPlaylist: widget.ytApiPlaylist,
                      urlDirect: tvUrl,
                      titre: apiItems?.allitems![0].title,
                      image: apiItems?.allitems![0].logo!.trim(),
                      select: apiItems?.allitems![0].id,
                      enabled: _enabled,
                    ))
                );
              } else{
                print('error');
              }
            },
          ),
          ListTile(

            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'SUNU LABEL TV',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold

                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              if (_enabled ==false) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>TvPageScreen(
                      data: apiItems?.allitems![1].feedUrl,
                      ytResult: widget.ytResult,
                      ytResultPlaylist: widget.ytResultPlaylist,
                      ytApi: widget.ytApi,
                      ytApiPlaylist: widget.ytApiPlaylist,
                      urlDirect: tvUrl,
                      titre: apiItems?.allitems![1].title,
                      image: apiItems?.allitems![1].logo!.trim(),
                      select: apiItems?.allitems![1].id,
                      enabled: _enabled,
                    ))
                );
              } else{
                print('error');
              }
            },
          ),
          ListTile(

            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:  Text(
                'REVOIR TV',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReplayerPage(
                  ytResult: widget.ytResult,
                  ytResultPlaylist: widget.ytResultPlaylist,
                  enable: _enabled, ytApiPlaylist: widget.ytApiPlaylist,
                ),
                ),

              );

            },
          ),
          ListTile(

            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:  Text(
                'YouTube',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,

            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => YoutubeVideoPlayList(
                  ytResult: widget.ytResult,
                  ytResultPlaylist: widget.ytResultPlaylist,
                  ytApi: widget.ytApi,
                  ytApiPlaylist: widget.ytApiPlaylist,
                  enabled: _enabled,
                ),
                ),

              );
            },
          ),

          SizedBox(
            height: 50,
          ),
          const Divider(
            color: dividerColor,
          ),
          SizedBox(
            height: 50,
          ),
          ListTile(

            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Facebook',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              _launchURLFacebook(widget.facebook);
            },
          ),
          ListTile(
            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'A propos',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold

                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>AproposPage(
                   description: widget.description,
                  ))
              );
            },
          ),
          ListTile(

            title: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Politique confidentialité',
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: textColor,
              size: 16,
            ),
            onTap: () {
              Navigator.push(context, PolicyPage.route());

            },
          ),
        ],
      ),
    );
  }
  void _launchURLFacebook(String url) async =>
      await canLaunch(url) ?
      await launch(url) :
      throw 'Could not launch ${url}';
}
