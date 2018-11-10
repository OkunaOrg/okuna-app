

import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class OBHomePosts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return OBHomePostsState();
  }
}

class OBHomePostsState extends State<OBHomePosts>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    UserService userService = provider.userService;

    // TODO: implement build
    return SizedBox();
  }


  void refreshPosts(){

  }
}