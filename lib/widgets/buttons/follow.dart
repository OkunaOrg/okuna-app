import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class OBFollowButton extends StatefulWidget {
  final User user;

  OBFollowButton(this.user);

  @override
  OBFollowButtonState createState() {
    return OBFollowButtonState();
  }
}

class OBFollowButtonState extends State<OBFollowButton> {
  UserService _userService;
  ToastService _toastService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    _userService = OpenbookProvider.of(context).userService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        return user.isFollowing ? _buildUnfollowButton() : _buildFollowButton();
      },
    );
  }

  Widget _buildFollowButton() {
    return FlatButton(
      color: Color(0xFF7ED321),
      child: Text(
        'Follow',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      onPressed: _followUser,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
    );
  }

  Widget _buildUnfollowButton() {
    return OutlineButton(
      color: Color(0xFF7ED321),
      child: Text(
        'Unfollow',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      borderSide: BorderSide(color: Color(0xFF7ED321)),
      onPressed: _unFollowUser,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
    );
  }

  void _followUser() async {
    _setRequestInProgress(true);
    try {
      _userService.followUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unFollowUser() async {
    _setRequestInProgress(true);
    try {
      _userService.unFollowUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
