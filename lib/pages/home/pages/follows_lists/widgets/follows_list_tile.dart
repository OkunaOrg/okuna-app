import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/pages/home/pages/post/widgets/expanded_post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/danger_button.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Openbook/services/httpie.dart';

class OBFollowsListTile extends StatefulWidget {
  final FollowsList followsList;
  final VoidCallback onFollowsListDeletedCallback;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;
  final bool isEditing;

  OBFollowsListTile(
      {@required this.followsList,
      Key key,
      this.onFollowsListDeletedCallback,
      this.isEditing,
      @required this.onWantsToSeeUserProfile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBFollowsListTileState();
  }
}

class OBFollowsListTileState extends State<OBFollowsListTile> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    return Container(
      child: ListTile(
        leading: OBFollowsListIcon(
          size: OBFollowsListIconSize.medium,
          followsListIconUrl: widget.followsList.getEmojiImage(),
        ),
        title: Text(widget.followsList.name),
        subtitle: Text(widget.followsList.followsCount.toString() + ' users'),
        trailing: widget.isEditing
            ? OBDangerButton(
                child: Text('Delete'),
                isLoading: _requestInProgress,
                size: OBButtonSize.small,
                onPressed: _deleteFollowsList,
              )
            : IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: null),
      ),
    );
  }

  void _deleteFollowsList() async {
    _setRequestInProgress(true);
    try {
      await _userService.deleteFollowsList(widget.followsList);
      // widget.post.decreaseCommentsCount();
      _setRequestInProgress(false);
      if (widget.onFollowsListDeletedCallback != null) {
        widget.onFollowsListDeletedCallback();
      }
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
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
