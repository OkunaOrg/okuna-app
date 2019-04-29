import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/navigation_service.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/alerts/alert.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/markdown.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBAcceptGuidelinesModal extends StatefulWidget {
  @override
  OBAcceptGuidelinesModalState createState() {
    return OBAcceptGuidelinesModalState();
  }
}

class OBAcceptGuidelinesModalState extends State {
  NavigationService _navigationService;
  ToastService _toastService;
  UserService _userService;
  String _guidelinesText;
  bool _needsBootstrap;
  bool _acceptButtonEnabled;
  bool _requestInProgress;
  ScrollController _guidelinesScrollController;

  CancelableOperation _getGuidelinesOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _requestInProgress = false;
    _guidelinesText = '';
    _acceptButtonEnabled = false;
    _guidelinesScrollController = ScrollController();
    _guidelinesScrollController.addListener(_onGuidelinesScroll);
  }

  @override
  void dispose() {
    super.dispose();
    if (_getGuidelinesOperation != null) _getGuidelinesOperation.cancel();
  }

  void _bootstrap() async {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    _getGuidelinesOperation = CancelableOperation.fromFuture(
        openbookProvider.documentsService.getCommunityGuidelines());

    String guidelines = await _getGuidelinesOperation.value;
    _setGuidelinesText(guidelines);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: CupertinoPageScaffold(
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: OBText(
                    'Please take a moment to read and accept our guidelines.',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: OBAlert(
                    child: ListView(
                      controller: _guidelinesScrollController,
                      children: <Widget>[
                        OBMarkdown(
                          onlyBody: true,
                          data: _guidelinesText,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: _buildPreviousButton(context: context),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(child: _buildNextButton()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return OBButton(
      type: OBButtonType.success,
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text('Accept', style: TextStyle(fontSize: 18.0)),
      isDisabled: !_acceptButtonEnabled && _guidelinesText.isNotEmpty,
      isLoading: _requestInProgress,
      onPressed: _acceptGuidelines,
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    return OBButton(
      type: OBButtonType.danger,
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Row(
        children: <Widget>[
          Text(
            'Reject',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        _navigationService.navigateToConfirmRejectGuidelinesPage(
            context: context);
      },
    );
  }

  Future _acceptGuidelines() async {
    _setRequestInProgress(true);
    try {
      await _userService.acceptGuidelines();
      await _userService.refreshUser();
      Navigator.pop(context);
    } catch (error) {
      _onError(error);
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

  void _setGuidelinesText(String guidelinesText) {
    setState(() {
      _guidelinesText = guidelinesText;
    });
  }

  void _onGuidelinesScroll() {
    if (!_acceptButtonEnabled &&
        _guidelinesScrollController.position.pixels >
            (_guidelinesScrollController.position.maxScrollExtent * 0.9)) {
      _setAcceptButtonEnabled(true);
    }
  }

  void _setAcceptButtonEnabled(bool acceptButtonEnabled) {
    setState(() {
      _acceptButtonEnabled = acceptButtonEnabled;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
