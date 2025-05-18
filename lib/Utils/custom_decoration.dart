
import 'package:flutter/material.dart';

class CustomDecoration{

  static BoxDecoration customBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xffC77EF7),
          Color(0xffE695D5),
          Color(0xffACCEE8)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static InputDecoration customInputDecoration({String labelText = ""}){
    return  InputDecoration(
      labelText: labelText ,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }

}