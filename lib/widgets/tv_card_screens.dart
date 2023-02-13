import 'package:flutter/cupertino.dart';

class TvCardScreens extends StatelessWidget {
  const TvCardScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ic_launcher.png')
                  )
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
