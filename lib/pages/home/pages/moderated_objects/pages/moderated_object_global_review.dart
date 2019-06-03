import 'package:Openbook/models/moderation/moderated_object.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_description/moderated_object_description.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_logs/moderated_object_logs.dart';
import 'package:Openbook/pages/home/pages/moderated_objects/pages/widgets/moderated_object_reports_preview/moderated_object_reports_preview.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectGlobalReviewPage extends StatefulWidget {
  final ModeratedObject moderatedObject;

  const OBModeratedObjectGlobalReviewPage(
      {Key key, @required this.moderatedObject})
      : super(key: key);

  @override
  OBModeratedObjectGlobalReviewPageState createState() {
    return OBModeratedObjectGlobalReviewPageState();
  }
}

class OBModeratedObjectGlobalReviewPageState
    extends State<OBModeratedObjectGlobalReviewPage> {
  bool _requestInProgress;
  bool _isEditable;

  UserService _userService;
  ToastService _toastService;
  bool _needsBootstrap;

  CancelableOperation _requestOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _isEditable = false;
    _requestInProgress = false;
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
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                OBModeratedObjectDescription(
                  isEditable: _isEditable,
                  moderatedObject: widget.moderatedObject,
                ),
                OBModeratedObjectCategory(
                  isEditable: _isEditable,
                  moderatedObject: widget.moderatedObject,
                ),
                OBModeratedObjectReportsPreview(
                  isEditable: _isEditable,
                  moderatedObject: widget.moderatedObject,
                ),
                OBModeratedObjectLogs(
                  moderatedObject: widget.moderatedObject,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: _buildPrimaryActions(),
          )
        ],
      ),
    );
  }

  Widget _buildPrimaryActions() {
    List<Widget> actions = [];

    if (widget.moderatedObject.verified) {
      actions.add(Expanded(
        child: OBButton(
          size: OBButtonSize.large,
          type: OBButtonType.danger,
          child: Text('Unverify'),
          onPressed: _onWantsToUnverifyModeratedObject,
          isLoading: _requestInProgress,
        ),
      ));
    } else {
      actions.add(Expanded(
        child: OBButton(
          size: OBButtonSize.large,
          type: OBButtonType.success,
          child: Text('Verify'),
          onPressed: _onWantsToVerifyModeratedObject,
          isLoading: _requestInProgress,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: actions,
    );
  }

  void _onWantsToVerifyModeratedObject() async {
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.verifyModeratedObject(widget.moderatedObject));
      await _requestOperation.value;
      widget.moderatedObject.setIsVerified(true);
      Navigator.pop(context);
    } catch (error) {
      _onError(error);
    }
  }

  void _onWantsToUnverifyModeratedObject() async {
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.unverifyModeratedObject(widget.moderatedObject));
      await _requestOperation.value;
      widget.moderatedObject.setIsVerified(false);
      Navigator.pop(context);
    } catch (error) {
      _onError(error);
    }
  }

  void _bootstrap() {
    _isEditable = !widget.moderatedObject.verified;
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
