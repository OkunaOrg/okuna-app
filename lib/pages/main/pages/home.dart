import 'package:flutter/cupertino.dart';

class MainHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainHomePageState();
  }
}

class MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Home page'),
        ),
        child: Center(
          child: CupertinoButton(child: Text('Push'), onPressed: (){
            Navigator.of(context).push(CupertinoPageRoute<void>(
              title: 'Pushed',
              builder: (BuildContext context) => CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(),
                child: Center(child: Text('Hi'),),),
            ));
          }),
        )
    );
  }
}
