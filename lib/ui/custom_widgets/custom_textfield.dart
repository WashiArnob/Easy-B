import 'package:flutter/material.dart';

customTextField(controller, labeltext, hinttext,keyboardType,validator) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: validator,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black.withOpacity(1.0), // Set the desired opacity value here
            width: 0.75,
          ),
          borderRadius: BorderRadius.circular(12),

        ),

        labelText: labeltext,
        hintText: hinttext),

  );
}


customTextFieldProducts(controller, labeltext, hinttext,keyboardType,validator,{secureText}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: secureText,
    validator: (String? value) {
    if (value!.isEmpty) {
      return "This field can't be empty";
    }
  },
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: labeltext,
        hintText: hinttext),

  );
}

// TextFormField(
// controller: controller,
// keyboardType: keyboardType,
// validator: validator,
// decoration: InputDecoration(
// filled: true,
// fillColor: Colors.grey.shade200,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12),
// borderSide: BorderSide(
// color: Colors.black.withOpacity(0.5), // Set the desired opacity value here
// width: 2.0,
// ),
// ),
// labelText: labeltext,
// hintText: hinttext,
// ),
// );