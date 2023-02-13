import 'package:flutter/cupertino.dart';
import 'package:labeltv/utils/colors.dart';

class TitreScreen extends StatelessWidget {
  final String? titre;
  TitreScreen({Key? key,this.titre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15,left: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 20,
        child: Text(titre!,style: TextStyle(fontSize: 15,color: textColor,fontFamily: 'Inter',fontWeight: FontWeight.bold),),
      ),
    );
  }
}
