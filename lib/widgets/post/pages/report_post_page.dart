import 'dart:convert';

import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_report.dart';
import 'package:Openbook/models/report_category.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/post_reports_api.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/fields/text_form_field.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReportPostPage extends StatefulWidget {
  final Post reportedPost;
  final ReportCategory reportedCategory;

  const OBReportPostPage(
      {Key key, @required this.reportedPost, @required this.reportedCategory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBReportPostPageState();
  }
}

class OBReportPostPageState extends State<OBReportPostPage> {
  bool _confirmationInProgress;
  PostReportsApiService _postReportsApiService;
  ToastService _toastService;
  UserService _userService;
  ValidationService _validationService;
  bool _needsBootstrap;
  TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
    _commentController = TextEditingController();
    _commentController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _postReportsApiService = openbookProvider.postReportsApiService;
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _validationService = openbookProvider.validationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(title: ''),
        child: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _getReportInformation(),
                  _getReportButtons()
                ],
              )
            ),
          )
        )
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  Widget _getReportInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
              children: <Widget>[
                OBIcon(
                  OBIcons.reportCommunity,
                  themeColor: OBIconThemeColor.primaryAccent,
                  size: OBIconSize.extraLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                OBText(
                  'Report as ${widget.reportedCategory.title} ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                OBText('We remove:'),
                const SizedBox(
                  height: 20,
                ),
                OBText('${widget.reportedCategory.description}'),
                const SizedBox(
                  height: 20,
                ),
                const OBText(
                    'If you report someones post, we do not tell them who reported it.'),
                const SizedBox(
                  height: 40,
                ),
                _getCommentField(),
                const SizedBox(
                  height: 20,
                ),
              ],
      ),
    );
  }

  Widget _getCommentField() {
    return Container(
      child: OBTextFormField(
        controller: _commentController,
        validator: (String text) {
          if (!_confirmationInProgress) return null;
          return _validationService.validatePostReportComment(text);
        },
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: 'Add a comment..',
          contentPadding: EdgeInsets.all(0.0)
        ),
      ),
    );
  }

  Widget _getReportButtons() {
    return Padding(
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
    );
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      await _userService.createPostReport(
          postId: widget.reportedPost.id,
          categoryName: widget.reportedCategory.name,
          comment: _commentController.text);
      Navigator.of(context).pop(true);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else if (error is HttpieRequestError) {
      List<dynamic> errorText = json.decode(await error.body());
      _toastService.error(message: errorText[0], context: context);
    } else {
      _toastService.error(message: 'Unknown error.', context: context);
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
