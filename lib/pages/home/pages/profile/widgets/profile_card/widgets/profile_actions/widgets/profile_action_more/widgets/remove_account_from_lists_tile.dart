import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBRemoveAccountFromLists extends StatefulWidget {
  final User user;
  final VoidCallback onRemovedAccountFromLists;

  const OBRemoveAccountFromLists(this.user,
      {Key key, this.onRemovedAccountFromLists})
      : super(key: key);

  @override
  OBRemoveAccountFromListsState createState() {
    return OBRemoveAccountFromListsState();
  }
}

class OBRemoveAccountFromListsState extends State<OBRemoveAccountFromLists> {
  UserService _userService;
  ToastService _toastService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return ListTile(
        title: OBText('Remove account from lists'),
        leading: OBIcon(OBIcons.removeFromList),
        onTap: _removeAccountFromLists);
  }

  Future _removeAccountFromLists() async {
    try {
      await _userService
          .updateFollowWithUsername(widget.user.username, followsLists: []);
      _toastService.success(message: 'Success', context: context);
      if (widget.onRemovedAccountFromLists != null)
        widget.onRemovedAccountFromLists();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
