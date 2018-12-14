import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/lib/base_state.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBOwnProfilePage extends StatefulWidget {
  final OBOwnProfilePageController controller;

  OBOwnProfilePage({
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return OBOwnProfilePageState();
  }
}

class OBOwnProfilePageState extends OBBasePageState<OBOwnProfilePage> {
  OBProfilePageController _profilePageController;

  @override
  void initState() {
    super.initState();
    _profilePageController = OBProfilePageController();
    if (widget.controller != null) widget.controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return StreamBuilder(
      stream: userService.loggedInUserChange,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var data = snapshot.data;
        if (data == null) return SizedBox();
        return OBProfilePage(
          data,
          controller: _profilePageController,
        );
      },
    );
  }

  void scrollToTop() {
    _profilePageController.scrollToTop();
  }
}

class OBOwnProfilePageController
    extends OBBasePageStateController<OBOwnProfilePageState> {
  void scrollToTop() {
    state.scrollToTop();
  }
}
