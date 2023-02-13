import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:labeltv/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
class GridViewScreen extends StatelessWidget {
  final String? text;
  final String? image;
  final VoidCallback? onTap;
  GridViewScreen({Key? key,this.image,this.text,this.onTap,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  child: CachedNetworkImage(
                    imageUrl: image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset(
                          "assets/images/cadre.png",
                          width: MediaQuery.of(context).size.width,height: 130,fit: BoxFit.cover,
                        ),
                    errorWidget: (context, url, error) =>
                        Image.asset(
                          "assets/images/cadre.png",width: MediaQuery.of(context).size.width,height: 130,fit: BoxFit.cover,
                        ),
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                  ),
                ),
              ),
              //SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(

                        child: Text(text!,
                          style: TextStyle(fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,fontSize: 12),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),

                    Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/docs.png'),

                        )
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
