import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderated_object_log.dart';
import 'package:Openbook/models/moderation/moderated_object_log_list.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_logs/widgets/moderated_object_log_tile/moderated_object_log_tile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectLogs extends StatefulWidget {
  final ModeratedObject moderatedObject;

  const OBModeratedObjectLogs({Key key, @required this.moderatedObject})
      : super(key: key);

  @override
  OBModeratedObjectLogsState createState() {
    return OBModeratedObjectLogsState();
  }
}

class OBModeratedObjectLogsState extends State<OBModeratedObjectLogs> {
  static int logssCount = 5;

  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;

  CancelableOperation _refreshLogsOperation;
  bool _refreshInProgress;
  List<ModeratedObjectLog> _logs;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _refreshInProgress = false;
    _logs = [];
  }

  @override
  void dispose() {
    super.dispose();
    if (_refreshLogsOperation != null) _refreshLogsOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _refreshLogs();
      _needsBootstrap = false;
      _refreshInProgress = true;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBTileGroupTitle(
          title: 'Logs',
        ),
        OBDivider(),
        _refreshInProgress
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: OBProgressIndicator(),
                  )
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.all(0),
                itemBuilder: _buildModerationLog,
                itemCount: _logs.length,
                shrinkWrap: true,
              ),
      ],
    );
  }

  Widget _buildModerationLog(BuildContext context, int index) {
    ModeratedObjectLog log = _logs[index];
    return OBModeratedObjectLogTile(
      log: log,
    );
  }

  Future _refreshLogs() async {
    _setRefreshInProgress(true);
    try {
      _refreshLogsOperation = CancelableOperation.fromFuture(_userService
          .getModeratedObjectLogs(widget.moderatedObject, count: 5));

      ModeratedObjectLogsList moderationLogsList =
          await _refreshLogsOperation.value;
      _setLogs(moderationLogsList.moderatedObjectLogs);
    } catch (error) {
      _onError(error);
    }
    _setRefreshInProgress(false);
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  void _setLogs(List<ModeratedObjectLog> logs) {
    setState(() {
      _logs = logs;
    });
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
}
