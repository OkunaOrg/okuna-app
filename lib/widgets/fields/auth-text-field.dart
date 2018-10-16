import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;

  final FocusNode focusNode;

  final TextInputAction textInputAction;

  final TextCapitalization textCapitalization;

  final TextAlign textAlign;

  final bool autofocus;

  final bool obscureText;

  final bool autocorrect;

  final int maxLength;

  final bool maxLengthEnforced;

  final ValueChanged<String> onChanged;

  final VoidCallback onEditingComplete;

  final ValueChanged<String> onSubmitted;

  final List<TextInputFormatter> inputFormatters;

  final bool enabled;

  final Brightness keyboardAppearance;

  final int maxLines;

  final String hintText;

  final Widget prefixIcon;

  final Widget suffixIcon;

  AuthTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.hintText,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.keyboardAppearance,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforced: maxLengthEnforced,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      enabled: enabled,
      keyboardAppearance: keyboardAppearance,
      autocorrect: autocorrect,
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      decoration: new InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      autofocus: autofocus,
    );
  }
}
