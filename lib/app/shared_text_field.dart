
import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';

class MyTextField extends StatelessWidget {
  MyTextField({required this.hint,required this.obscureText , required this.inputType, required this.takeValue, required this.controller});

  final String hint;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final Function takeValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
      child: TextField(
        obscureText: obscureText,
        keyboardType: inputType,
        textAlign: TextAlign.start,
        onChanged: (value){
          takeValue(value);
        },
        controller: controller,
        decoration: InputDecoration(
            //hintText: hint,
            labelText: hint,
            contentPadding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey,width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange,width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))
            )
        ),
      ),
    )
    ;
  }
}
