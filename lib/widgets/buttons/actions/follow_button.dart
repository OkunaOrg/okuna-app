import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/buttons/button.dart';
export 'package:Okuna/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBFollowButton extends StatefulWidget {
  final User user;
  final OBButtonSize size;
  final OBButtonType unfollowButtonType;

  OBFollowButton(this.user,
      {this.size = OBButtonSize.medium,
      this.unfollowButtonType = OBButtonType.primary});

  @override
  OBFollowButtonState createState() {
    return OBFollowButtonState();
  }
}

class OBFollowButtonState extends State<OBFollowButton> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        if (user?.isFollowing == null) return const SizedBox();

        return user.isFollowing ? _buildUnfollowButton() : _buildFollowButton();
      },
    );
  }

  Widget _buildFollowButton() {
    return OBButton(
      size: widget.size,
      child: Text(
        _localizationService.user__follow_button_follow_text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _followUser,
    );
  }

  Widget _buildUnfollowButton() {
    return OBButton(
      size: widget.size,
      child: Text(
        _localizationService.user__follow_button_unfollow_text,
      ),
      isLoading: _requestInProgress,
      onPressed: _unFollowUser,
      type: widget.unfollowButtonType,
    );
  }

  void _followUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.followUserWithUsername(widget.user.username);
      widget.user.incrementFollowersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unFollowUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unFollowUserWithUsername(widget.user.username);
      widget.user.decrementFollowersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
