import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/buttons/button.dart';
export 'package:Okuna/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBUserSubscribeButton extends StatefulWidget {
  final User user;
  final OBButtonSize size;
  final OBButtonType unsubscribeButtonType;

  OBUserSubscribeButton(this.user,
      {this.size = OBButtonSize.medium,
      this.unsubscribeButtonType = OBButtonType.primary});

  @override
  OBUserSubscribeButtonState createState() {
    return OBUserSubscribeButtonState();
  }
}

class OBUserSubscribeButtonState extends State<OBUserSubscribeButton> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
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
    _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        if (user?.isSubscribed == null) return const SizedBox();

        return user.isSubscribed ? _buildUnsubscribeButton() : _buildSubscribeButton();
      },
    );
  }

  Widget _buildSubscribeButton() {
    return OBButton(
      size: widget.size,
      child: Text(
        _localizationService.user__subscribe_button_subscribe_text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _subscribeUser,
    );
  }

  Widget _buildUnsubscribeButton() {
    return OBButton(
      size: widget.size,
      child: Text(
        _localizationService.user__unsubscribe_button_unsubscribe_text,
      ),
      isLoading: _requestInProgress,
      onPressed: _unSubscribeUser,
      type: widget.unsubscribeButtonType,
    );
  }

  void _subscribeUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.subscribeUser(widget.user);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unSubscribeUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unsubscribeUser(widget.user);
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
      _toastService.error(message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
