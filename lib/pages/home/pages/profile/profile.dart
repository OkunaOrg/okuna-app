import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfilePage extends StatefulWidget {
  User user;

  OBProfilePage(this.user);

  @override
  OBProfilePageState createState() {
    return OBProfilePageState();
  }
}

class OBProfilePageState extends State<OBProfilePage> {
  User _user;
  bool _needsBootstrap;
  bool _refreshUserInProgress;
  UserService _userService;
  ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _refreshUserInProgress = false;
    _needsBootstrap = true;
    _user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    String username = _user.username;
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Container(
        child: Text('Profile of user $username'),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text('Profile'),
    );
  }

  void _bootstrap() async {
    await _refreshUser();
  }

  void _refreshUser() async {
    _setRefreshUserInProgress(true);

    try {
      var user = await _userService.getUserWithUsername(_user.username);
      _setUser(user);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection');
    } catch (e) {
      _toastService.error(message: 'Unknown error.');
      rethrow;
    } finally {
      _setRefreshUserInProgress(false);
    }
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }

  void _setRefreshUserInProgress(bool refreshUserInProgress) {
    setState(() {
      this._refreshUserInProgress = refreshUserInProgress;
    });
  }
}
