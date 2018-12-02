import 'package:flutter/material.dart';

class OBProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 20.0,
        maxWidth: 20.0,
      ),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }
}
