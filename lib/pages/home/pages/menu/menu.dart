import 'package:Openbook/pages/home/pages/menu/widgets/body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainMenuPage extends StatelessWidget {
  OBMainMenuPage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Container(
        child: Column(
          children: <Widget>[Expanded(child: OBMainMenuBody())],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Menu'),
    );
  }
}
