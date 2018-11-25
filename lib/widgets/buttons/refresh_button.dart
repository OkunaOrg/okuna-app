import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  OBRefreshButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    var icon = isLoading
        ? _getLoadingIndicator()
        : Icon(Icons.refresh, color: Colors.black);

    return IconButton(
      icon: icon,
      onPressed: onPressed,
    );
  }

  Widget _getLoadingIndicator() {
    return SizedBox(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)),
    );
  }
}
