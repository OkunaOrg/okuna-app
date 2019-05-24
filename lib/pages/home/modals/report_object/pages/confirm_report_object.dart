import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';

class OBConfirmReportObject extends StatefulWidget {
  final dynamic object;
  final ModerationCategory category;

  const OBConfirmReportObject(
      {Key key, @required this.object, @required this.category})
      : super(key: key);

  @override
  OBConfirmReportObjectState createState() {
    return OBConfirmReportObjectState();
  }
}

class OBConfirmReportObjectState extends State<OBConfirmReportObject> {
  bool _confirmationInProgress;
  UserService _userService;
  ToastService _toastService;
  bool _needsBootstrap;

  String description;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: 'Confirmation'),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBIcon(
                      OBIcons.report,
                      themeColor: OBIconThemeColor.primaryAccent,
                      size: OBIconSize.extraLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBText(
                      'You are about to report this item.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const OBText('The report is anonymous.')
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      child: Text('No'),
                      onPressed: _onCancel,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: Text('Yes'),
                      onPressed: _onConfirm,
                      isLoading: _confirmationInProgress,
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      Future reportFuture;
      if (widget.object is Post) {
        reportFuture = _userService.reportPost(
            post: widget.object, moderationCategory: widget.category);
      } else if (widget.object is PostComment) {
        reportFuture = _userService.reportPostComment(
            postComment: widget.object, moderationCategory: widget.category);
      } else if (widget.object is Community) {
        reportFuture = _userService.reportCommunity(
            community: widget.object, moderationCategory: widget.category);
      } else if (widget.object is User) {
        reportFuture = _userService.reportUser(
            user: widget.object, moderationCategory: widget.category);
      } else {
        throw 'Object type not supported';
      }

      Navigator.of(context).pop(true);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
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

  void _onCancel() {
    Navigator.of(context).pop(false);
  }

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }
}
