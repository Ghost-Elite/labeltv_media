import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/network/apiService.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
import '../utils/constants.dart';
import 'mobile_home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var logger= Logger();
  late ApiService apiService;
  bool isLoading = false;
  YoutubeAPI? ytApi;
  YoutubeAPI? ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoadingPlaylist = true;

  Future<void> callAPI() async {
    //print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi!.channel(API_CHANEL);


    setState(() {

      isLoading = true;
      callAPIPlaylist();

    });
  }
  Future<void> callAPIPlaylist() async {
    //print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist!.playlist(API_CHANEL);

    setState(() {
      //print('UI Updated');
      //print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
    print(ytResultPlaylist.length);
  }
  Future<ApiService?> fetchConnexion() async {

    try {
      var postListUrl =
      Uri.parse("https://tveapi.acan.group/myapiv2/appdetails/labeltv/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        //print(data);
        //logger.w('message',jsonDecode(response.body));
        setState(() {
          apiService = ApiService.fromJson(jsonDecode(response.body));

        });
        //logger.w('Call Of Duty',apiService!.aCANAPI![0].appDataUrl);

      }
    } catch (error, stacktrace) {
      internetProblem();

      return ApiService.withError("Data not found / Connection issue");
    }


  }
  Object internetProblem() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: Column(
          children: [
            Text(
              'Label TV',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textAppBarColor),
            )
          ],
        ),
        content: Text(
          "Problème d\'accès à Internet, veuillez vérifier votre connexion et réessayez !!!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textAppBarColor),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const SplashScreen()));
                },
                child: Container(
                  width: 120,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: textAppBarColor,
                      borderRadius: BorderRadius.circular(35)),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Réessayer",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appBarColor),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ytApi = YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist = YoutubeAPI(API_Key, maxResults: 50, type: "playlist");
    callAPI();
    fetchConnexion();
    startTime();
  }
  startTime() async {
    var _duration = const Duration(seconds: 5);

    return Timer(_duration, navigationPage);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var bg = Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splashScreen.png"),
                fit: BoxFit.fill
            ),
          ),
        ),

      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          bg,
          Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: Platform.isIOS?200:300,),

                ],
              )
          ),
        ],
        ),
      ),
    );
  }
  Future<void> navigationPage()async {
    if(apiService !=null && apiService!=0){
       //print(ytResult![1].duration);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MobileLayoutScreen(
          url: apiService!.aCANAPI![0].appDataUrl,
          description: apiService!.aCANAPI![0].appDescription,
          ytApi: ytApi,
          ytResult: ytResult,
          ytResultPlaylist: ytResultPlaylist,
          isLoading: isLoading,
          facebook:  apiService!.aCANAPI![0].appFbUrl,
        ),
        ),
            (Route<dynamic> route) => false,
      );
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RadioPlayerScreen(

        ),
        ),

      );*/
    }else{

    }

  }
}
