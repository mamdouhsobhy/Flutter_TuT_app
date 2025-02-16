import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';

class MyButton extends StatelessWidget {
  MyButton({required this.color, required this.buttonText, required this.fun});

  final Color color;
  final String buttonText;
  final Function fun;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(minWidth: 120,height: 42,splashColor: color,onPressed: (){
          fun();
        },child: Text(buttonText,style: TextStyle(color: Colors.white),
        ),
        ),
      ),
    );
  }
}
