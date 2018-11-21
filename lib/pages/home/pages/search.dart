import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBMainSearchPageState();
  }
}

class OBMainSearchPageState extends State<OBMainSearchPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Search'),
        ),
        child: Center(
          child: TextField(),
        ));
  }
}
