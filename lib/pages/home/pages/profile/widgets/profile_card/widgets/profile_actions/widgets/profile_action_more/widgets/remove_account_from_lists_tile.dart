import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/localization.dart';
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
  LocalizationService _localizationService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    return ListTile(
        title: OBText(_localizationService.trans('user__remove_account_from_list')),
        leading: const OBIcon(OBIcons.removeFromList),
        onTap: _removeAccountFromLists);
  }

  Future _removeAccountFromLists() async {
    try {
      await _userService
          .updateFollowWithUsername(widget.user.username, followsLists: []);
      _toastService.success(message: _localizationService.trans('user__remove_account_from_list_success'), context: context);
      if (widget.onRemovedAccountFromLists != null)
        widget.onRemovedAccountFromLists();
    } catch (error) {
      _onError(error);
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
      _toastService.error(message: _localizationService.trans('error__unknown_error'), context: context);
      throw error;
    }
  }
}
