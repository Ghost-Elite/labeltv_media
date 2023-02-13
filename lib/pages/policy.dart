import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class PolicyPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const PolicyPage(),
  );
  const PolicyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: textAppBarColor,),
        backgroundColor: appBarColor,
        title: Text('Politique de confidentialité',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: textAppBarColor),),


      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewPlusController webViewPlusController) async {
            _controller = webViewPlusController;
            await loadHtmlFromAssets('assets/html/politique.html',_controller);
          },
        ),
      ),
    );
  }
}
