import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_description/moderated_object_description.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_logs/moderated_object_logs.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_reports_preview/moderated_object_reports_preview.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_preview.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/tile_group_title.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectCommunityReviewPage extends StatefulWidget {
  final ModeratedObject moderatedObject;
  final Community community;

  const OBModeratedObjectCommunityReviewPage(
      {Key key, @required this.moderatedObject, @required this.community})
      : super(key: key);

  @override
  OBModeratedObjectCommunityReviewPageState createState() {
    return OBModeratedObjectCommunityReviewPageState();
  }
}

class OBModeratedObjectCommunityReviewPageState
    extends State<OBModeratedObjectCommunityReviewPage> {
  bool _requestInProgress;
  bool _isEditable;

  UserService _userService;
  ToastService _toastService;
  bool _needsBootstrap;

  CancelableOperation _requestOperation;
  OBModeratedObjectLogsController _logsController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _isEditable = false;
    _logsController = OBModeratedObjectLogsController();
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Review moderated object',
      ),
      child: OBPrimaryColorContainer(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                OBTileGroupTitle(
                  title: 'Object',
                ),
                OBModeratedObjectPreview(
                  moderatedObject: widget.moderatedObject,
                ),
                SizedBox(
                  height: 10,
                ),
                OBModeratedObjectDescription(
                    isEditable: _isEditable,
                    moderatedObject: widget.moderatedObject,
                    onDescriptionChanged: _onDescriptionChanged),
                OBModeratedObjectCategory(
                    isEditable: _isEditable,
                    moderatedObject: widget.moderatedObject,
                    onCategoryChanged: _onCategoryChanged),
                OBModeratedObjectReportsPreview(
                  isEditable: _isEditable,
                  moderatedObject: widget.moderatedObject,
                ),
                OBModeratedObjectLogs(
                  moderatedObject: widget.moderatedObject,
                  controller: _logsController,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildPrimaryActions(),
          )
        ],
      )),
    );
  }

  Widget _buildPrimaryActions() {
    List<Widget> actions = [];

    if (widget.moderatedObject.status == ModeratedObjectStatus.pending) {
      actions.addAll([
        Expanded(
          child: OBButton(
            size: OBButtonSize.large,
            type: OBButtonType.danger,
            child: Text('Reject'),
            onPressed: _onWantsToRejectModeratedObject,
            isLoading: _requestInProgress,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: OBButton(
            size: OBButtonSize.large,
            child: Text('Approve'),
            onPressed: _onWantsToApproveModeratedObject,
            isLoading: _requestInProgress,
          ),
        )
      ]);
    } else {
      actions.add(
        Expanded(
          child: OBButton(
            size: OBButtonSize.large,
            type: OBButtonType.primary,
            child: Text('This item has been verified'),
            onPressed: null,
          ),
        ),
      );
    }

    return Row(
      children: actions,
    );
  }

  void _onDescriptionChanged(String newDescription) {
    _refreshLogs();
  }

  void _onCategoryChanged(ModerationCategory newCategory) {
    _refreshLogs();
  }

  void _refreshLogs() {
    _logsController.refreshLogs();
  }

  void _onWantsToApproveModeratedObject() async {
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.approveModeratedObject(widget.moderatedObject));
      await _requestOperation.value;
      widget.moderatedObject.setIsApproved();
      _updateIsEditable();
    } catch (error) {
      _onError(error);
    }
  }

  void _onWantsToRejectModeratedObject() async {
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.rejectModeratedObject(widget.moderatedObject));
      await _requestOperation.value;
      widget.moderatedObject.setIsRejected();
      _updateIsEditable();
    } catch (error) {
      _onError(error);
    }
  }

  void _bootstrap() {
    _isEditable =
        widget.moderatedObject.status == ModeratedObjectStatus.pending;
  }

  void _updateIsEditable() {
    setState(() {
      _isEditable =
          widget.moderatedObject.status == ModeratedObjectStatus.pending;
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
