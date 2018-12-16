import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBDenyConnectionButton extends StatefulWidget {
  final User user;

  OBDenyConnectionButton(this.user);

  @override
  OBDenyConnectionButtonState createState() {
    return OBDenyConnectionButtonState();
  }
}

class OBDenyConnectionButtonState extends State<OBDenyConnectionButton> {
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

        if (user?.isPendingConnectionConfirmation == null || !user.isConnected || !user.isPendingConnectionConfirmation)
          return SizedBox();

        return _buildDenyConnectionButton();
      },
    );
  }

  Widget _buildDenyConnectionButton() {
    return OBButton(
      child: Text(
        'Deny',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      isLoading: _requestInProgress,
      onPressed: _disconnectFromUser,
      type: OBButtonType.danger,
    );
  }

  Future _disconnectFromUser() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username);
      widget.user.decrementFollowersCount();
      _toastService.success(
          message: 'Disconnected successfully', context: context);
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
