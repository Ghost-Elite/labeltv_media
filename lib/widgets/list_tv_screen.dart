import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labeltv/utils/colors.dart';

class ListTvScreen extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  ListTvScreen({Key? key,this.onTap,this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 20,bottom: 25),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.40,
          height: 94,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: color!,
                    //blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 2.3
                ),
              ]
          ),
        ),
      ),
    );
  }
}
