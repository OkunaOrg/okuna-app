import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostActionsBottomSheet extends StatefulWidget {
  final Post post;
  final OnPostReported onPostReported;
  final OnPostDeleted onPostDeleted;

  const OBPostActionsBottomSheet(
      {Key key,
      @required this.post,
      @required this.onPostReported,
      @required this.onPostDeleted})
      : super(key: key);

  @override
  OBPostActionsBottomSheetState createState() {
    return OBPostActionsBottomSheetState();
  }
}

class OBPostActionsBottomSheetState extends State<OBPostActionsBottomSheet> {
  UserService _userService;
  ToastService _toastService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    List<Widget> postActions = [];

    User loggedInUser = _userService.getLoggedInUser();

    bool loggedInUserIsPostCreator =
        loggedInUser.id == widget.post.getCreatorId();
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;

    Post post = widget.post;

    if (post.hasCommunity()) {
      Community postCommunity = post.community;

      loggedInUserIsCommunityAdministrator =
          postCommunity.isAdministrator(loggedInUser);

      loggedInUserIsCommunityModerator =
          postCommunity.isModerator(loggedInUser);
    }

    if (loggedInUserIsPostCreator ||
        loggedInUserIsCommunityAdministrator ||
        loggedInUserIsCommunityModerator) {
      postActions.add(ListTile(
        leading: const OBIcon(OBIcons.deletePost),
        title: const OBText(
          'Delete post',
        ),
        onTap: _onWantsToDeletePost,
      ));
    } else {
      postActions.add(ListTile(
        leading: const OBIcon(OBIcons.reportPost),
        title: const OBText(
          'Report post',
        ),
        onTap: _onWantsToReportPost,
      ));
    }

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Column(
        children: postActions,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Future _onWantsToDeletePost() async {
    try {
      await _userService.deletePost(widget.post);
      _toastService.success(message: 'Post deleted', context: context);
      widget.onPostDeleted(widget.post);
      Navigator.pop(context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }

  void _onWantsToReportPost() async {
    _toastService.error(message: 'Not implemented yet', context: context);
    Navigator.pop(context);
  }
}

typedef OnPostReported(Post post);
typedef OnPostDeleted(Post post);
