import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class AproposPage extends StatefulWidget {

  var description;
  AproposPage({Key? key,this.description}) : super(key: key);

  @override
  State<AproposPage> createState() => _AproposPageState();
}

class _AproposPageState extends State<AproposPage> {
  var datas;
  Future<void> getDescription() async {
    try {
      var url =Uri.parse(widget.description);
      final response = await http.get(url);
      if (response.statusCode ==200) {
        final data = jsonDecode(response.body);
       setState(() {
         datas =data;
       });
       print(datas['app_description']);
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  WebViewPlusController? _controller;
  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  double _height = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDescription();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: textAppBarColor,),
        backgroundColor: appBarColor,
        title: Text('A propos',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: textAppBarColor),),


      ),
      body: datas !=null && datas !=0
          ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
            child: Container(
              color: Colors.white,

              child: HtmlWidget(
                  datas['app_description'],
                  textStyle: TextStyle(color: textColor),
              ),
            ),
          )

      )
          : Center(child: CircularProgressIndicator(backgroundColor: textAppBarColor,color: textAppBarColor,),),
    );
  }
}
