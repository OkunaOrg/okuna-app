import 'package:flutter/material.dart';

class OBProgressIndicator extends StatelessWidget {

  final Color color;

  const OBProgressIndicator({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 20.0,
        maxWidth: 20.0,
      ),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
