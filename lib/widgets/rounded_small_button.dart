import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  const RoundedSmallButton({Key? key, this.textColor=Colors.white, this.backgroundColor = Colors.green,required this.onTap,required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
          label: Text(label,
            style: TextStyle(color: textColor,fontSize: 16),
          ),
        backgroundColor: backgroundColor,
        labelPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),

      ),
    );
  }
}
