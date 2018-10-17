import 'package:flutter/cupertino.dart';

class MainSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainSearchPageState();
  }
}

class MainSearchPageState extends State<MainSearchPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Search page'),
        ),
        child: Center(
          child: Text('What'),
        )
    );
  }
}
