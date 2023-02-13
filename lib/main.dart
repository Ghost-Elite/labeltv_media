import 'package:flutter/material.dart';
import 'package:labeltv/pages/mobile_home_screen.dart';
import 'package:labeltv/pages/splash.dart';
import 'package:labeltv/pages/test.dart';
import 'package:labeltv/pages/web_home_screen.dart';
import 'package:labeltv/utils/colors.dart';

import 'configs/responsive.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Label TV',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home:  YoutubeAppDemo(),
    );
  }
}


