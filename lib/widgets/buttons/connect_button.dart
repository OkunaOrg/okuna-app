import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:flutter/material.dart';

class OBConnectButton extends StatefulWidget {
  final User user;

  OBConnectButton(this.user);

  @override
  OBConnectButtonState createState() {
    return OBConnectButtonState();
  }
}

class OBConnectButtonState extends State<OBConnectButton> {
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

        if (user?.isConnected == null) return SizedBox();

        return user.isConnected ? _buildDisconnectButton() : _buildConnectButton();
      },
    );
  }

  Widget _buildConnectButton() {
    return OBSuccessButton(
      child: Text(
        'Connect',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _connectUser,
    );
  }

  Widget _buildDisconnectButton() {
    return OBSuccessButton(
      isOutlined: true,
      child: Text(
        'Disconnect',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _disconnectUser,
    );
  }

  void _connectUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.connectWithUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _disconnectUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
