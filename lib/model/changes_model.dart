import 'package:flutter/material.dart';

//this is a class to hold the model for the textfields for making the various changes
class ChangeTextFields extends StatelessWidget {
 final IconData icon;
 final String hint;
 final TextInputType keyboard;
 ChangeTextFields({required this.hint,required this.icon, required this.keyboard});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child:TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon),
        ),
        keyboardType: keyboard,
      ),
    );
  }
}
