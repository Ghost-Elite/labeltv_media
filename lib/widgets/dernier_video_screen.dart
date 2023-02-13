import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:labeltv/utils/colors.dart';
class DernierVideoScreen extends StatelessWidget {
  final String? image;
  final String? texte;
  final String? date;
  final VoidCallback? onTap;
  Color? color = Colors.transparent;
  var select;
  DernierVideoScreen({Key? key, this.color,this.select,this.image,this.texte,this.date,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 4),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 104,
          /*color: Colors.white,*/
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
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: 104,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      height: 104,
                      width: MediaQuery.of(context).size.width * 0.35,
                      imageUrl:  image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset(
                        "assets/images/cadre.png",
                        fit: BoxFit.cover,
                        height: 104,
                        width: MediaQuery.of(context).size.width * 0.35,
                        //color: colorPrimary,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/cadre.png",
                        fit: BoxFit.cover,
                        height: 104,
                        width: MediaQuery.of(context).size.width * 0.35,
                        //color: colorPrimary,
                      ),
                    ),
                    Positioned(
                      bottom: -9,
                      right: -10,
                      child: IconButton(
                        icon: Icon(
                          Icons.play_circle_fill,
                          color: textSecondaryColor,
                        ),
                        onPressed: () {

                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.61,
                height: 104,

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.61,
                        height: 60,
                        child: Text(texte!,style: TextStyle(color: textColor,fontFamily: 'Inter',fontSize: 14),
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4,left: 10),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(date!,style: TextStyle(fontSize: 12,color: textSecondaryColor),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
