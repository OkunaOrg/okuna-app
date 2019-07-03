import 'package:Openbook/libs/type_to_str.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/moderation/moderation_category.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/markdown.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBConfirmReportObject extends StatefulWidget {
  final dynamic object;
  final Map<String, dynamic> extraData;
  final ModerationCategory category;

  const OBConfirmReportObject(
      {Key key, @required this.object, @required this.category, this.extraData})
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
  TextEditingController _descriptionController;

  String description;

  CancelableOperation _submitReportOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    if (_submitReportOperation != null) _submitReportOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: 'Submit report'),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBText(
                      'Can you provide extra details that might be relevant to the report?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBSecondaryText(
                      '(Optional)',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBAlert(
                      padding: const EdgeInsets.all(10),
                      child: OBTextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        hasBorder: false,
                        decoration: const InputDecoration(
                          hintText: 'Type here...',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OBText(
                      'Here\'s what will happen next:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBMarkdown(
                        onlyBody: true,
                        data: '- Your report will be submitted anonymously. \n '
                            '- If you are reporting a post or comment, the report will be sent to the Openspace staff and the community moderators if applicable and the post will be hidden from your feed \n'
                            '- If you are reporting an account or community, it will be sent to the Openspace staff. \n'
                            '- We\'ll review it, if approved, content will be deleted and penalties delivered to the people involved ranging from deletion of account to hours of suspension depending on the severity of the report. \n'
                            '- If the report is found to be made in an attempt to damage another member or community in the platform with no infringement of the stated reason, penalties will be applied to you. \n')
                  ],
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      child: Text('I understand, submit.'),
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
      if (widget.object is Post) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportPost(
                description: _descriptionController.text,
                post: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is PostComment) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportPostComment(
                description: _descriptionController.text,
                post: widget.extraData['post'],
                postComment: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is Community) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportCommunity(
                description: _descriptionController.text,
                community: widget.object,
                moderationCategory: widget.category));
      } else if (widget.object is User) {
        _submitReportOperation = CancelableOperation.fromFuture(
            _userService.reportUser(
                description: _descriptionController.text,
                user: widget.object,
                moderationCategory: widget.category));
      } else {
        throw 'Object type not supported';
      }
      await _submitReportOperation.value;
      if (widget.object is User ||
          widget.object is Community ||
          widget.object is Post ||
          widget.object is PostComment) {
        widget.object.setIsReported(true);
      }
      _toastService.success(
          message:
              modelTypeToString(widget.object, capitalize: true) + ' reported',
          context: context);
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

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }
}
