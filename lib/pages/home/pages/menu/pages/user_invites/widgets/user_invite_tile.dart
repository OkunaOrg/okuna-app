import 'package:Openbook/models/user_invite.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBUserInviteTile extends StatefulWidget {
  final UserInvite userInvite;
  final VoidCallback onUserInviteDeletedCallback;

  OBUserInviteTile(
      {@required this.userInvite, Key key, this.onUserInviteDeletedCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBUserInviteTileState();
  }
}

class OBUserInviteTileState extends State<OBUserInviteTile> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;

  CancelableOperation _deleteOperation;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_deleteOperation != null)
      _deleteOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;
    var navigationService = provider.navigationService;
    Widget tile;

    if (widget.userInvite.createdUser != null) {
      tile = ListTile(
          onTap: () {
              navigationService.navigateToUserProfile(
                  user: widget.userInvite.createdUser,
                  context: context);
          },
          leading: const OBIcon(OBIcons.invite),
          title: OBText(
            widget.userInvite.nickname,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: _buildActionableSecondaryText()
      );
    } else {
      tile = Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: ListTile(
            onTap: () {
                navigationService.navigateToInviteDetailPage(
                    userInvite: widget.userInvite,
                    context: context
                );
            },
            leading: const OBIcon(OBIcons.invite),
            title: OBText(
              widget.userInvite.nickname,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: _buildActionableSecondaryText()),
        secondaryActions: <Widget>[
          new IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: _deleteUserInvite),
        ],
      );
    }

    if (_requestInProgress) {
      tile = Opacity(opacity: 0.5, child: tile);
    }
    return tile;
  }

  Widget _buildActionableSecondaryText() {
    if (widget.userInvite.createdUser != null) {
      return OBActionableSmartText(
        size: OBTextSize.mediumSecondary,
        text: 'Joined with username @${widget.userInvite.createdUser.username}',
      );
    } else {
      return OBSecondaryText('Pending');
    }
  }

  void _deleteUserInvite() async {
    _setRequestInProgress(true);
    try {
      _deleteOperation = CancelableOperation.fromFuture(_userService.deleteUserInvite(widget.userInvite));
      await _deleteOperation.value;
      _setRequestInProgress(false);
      if (widget.onUserInviteDeletedCallback != null) {
        widget.onUserInviteDeletedCallback();
      }
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
      _deleteOperation = null;
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
