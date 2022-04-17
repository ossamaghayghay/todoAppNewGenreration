import 'package:flutter/material.dart';
import '../theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key,required this.label,required this.onTap}) : super(key: key);
  final Text label;
  final Function() onTap;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector
    (
      onTap: onTap,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 45,
          // color: Colors.pinkAccent,
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: primaryClr,
          ),
         
          child: label,
        ),
      ),
    );
  }
}
