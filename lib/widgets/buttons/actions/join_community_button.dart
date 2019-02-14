import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/community_button.dart';
import 'package:flutter/material.dart';

class OBJoinCommunityButton extends StatefulWidget {
  final Community community;

  OBJoinCommunityButton(this.community);

  @override
  OBJoinCommunityButtonState createState() {
    return OBJoinCommunityButtonState();
  }
}

class OBJoinCommunityButtonState extends State<OBJoinCommunityButton> {
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
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.community.updateSubject,
      initialData: widget.community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        bool isCreator = community.isCreator ?? true;

        if (community == null || isCreator) return SizedBox();

        bool isInvited = community.isInvited ?? false;
        bool isMember = community.isMember ?? false;

        if (community.type == CommunityType.private && !isMember && !isInvited)
          return SizedBox();

        return OBCommunityButton(
          community: community,
          text: isMember ? 'Leave' : 'Join',
          isLoading: _requestInProgress,
          onPressed: isMember ? _leaveCommunity : _joinCommunity,
        );
      },
    );
  }

  void _joinCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.joinCommunity(widget.community);
      //widget.community.incrementFollowersCount();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _leaveCommunity() async {
    _setRequestInProgress(true);
    try {
      await _userService.leaveCommunity(widget.community);
      //widget.community.decrementFollowersCount();
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
