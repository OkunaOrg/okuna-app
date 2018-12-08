import 'package:flutter/material.dart';

class OBTextField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final Widget prefixIcon;
  final String hintText;
  final String labelText;
  final bool autofocus;

  OBTextField(
      {this.controller,
      this.validator,
      this.prefixIcon,
      this.hintText,
      this.autofocus = false,
      this.labelText});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: autofocus,
              controller: controller,
              validator: validator,
              style: TextStyle(fontSize: 22, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hintText,
                labelStyle: TextStyle(
                    height: 0.60,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 21),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                border: InputBorder.none,
                labelText: labelText,
                prefixIcon: prefixIcon,
              ),
            ),
            Divider()
          ],
        ));
  }
}
