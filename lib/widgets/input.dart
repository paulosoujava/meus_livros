import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyInputText extends StatelessWidget {
  String title;
  String hint;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  bool isPass;
  Color color;

  MyInputText(
      this.title, this.hint, this.controller, this.validator, this.keyboardType,
      {this.textInputAction,
      this.focusNode,
      this.nextFocus,
      this.isPass = false,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      keyboardAppearance: Brightness.light,
      textInputAction: textInputAction,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onFieldSubmitted: (String str) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      validator: validator,
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),

        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
        ) ,
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
        ) ,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4)
        ),
        labelText: title,
        hintText: hint,
      ),
    );
  }
}
