import 'package:flutter/material.dart';

class OBScrollContainer extends InheritedWidget {
  final ScrollView scroll;

  const OBScrollContainer({Key key, this.scroll})
      : super(key: key, child: scroll);

  @override
  bool updateShouldNotify(OBScrollContainer old) {
    return false;
  }
}
