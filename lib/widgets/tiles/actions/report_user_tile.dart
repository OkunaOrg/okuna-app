import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportUserTile extends StatefulWidget {
  final User user;
  final VoidCallback onReportedUser;
  final VoidCallback onUnreportedUser;

  const OBReportUserTile({
    Key key,
    @required this.user,
    this.onReportedUser,
    this.onUnreportedUser,
  }) : super(key: key);

  @override
  OBReportUserTileState createState() {
    return OBReportUserTileState();
  }
}

class OBReportUserTileState extends State<OBReportUserTile> {
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
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        bool isReported = user.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(
              isReported ? 'Report account' : 'You have reported this account'),
          onTap: isReported ? () {} : _reportUser,
        );
      },
    );
  }

  void _reportUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.reportUser(widget.user);
      if (widget.onReportedUser != null) widget.onReportedUser();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unreportUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unreportUser(widget.user);
      if (widget.onUnreportedUser != null) widget.onUnreportedUser();
    } catch (e) {
      _onError(e);
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
