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

class OBAddAccountToList extends StatefulWidget {
  final User user;
  final VoidCallback onWillShowModalBottomSheet;

  const OBAddAccountToList(this.user, {Key key, this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBAddAccountToListState createState() {
    return OBAddAccountToListState();
  }
}

class OBAddAccountToListState extends State<OBAddAccountToList> {
  UserService _userService;
  ToastService _toastService;
  BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    bool hasFollowLists = widget.user.hasFollowLists();

    return ListTile(
        title: OBText(hasFollowLists
            ? 'Update account lists'
            : 'Add account to list'),
        leading: OBIcon(hasFollowLists ? OBIcons.lists : OBIcons.addToList),
        onTap: _displayAddConnectionToFollowsListsBottomSheet);
  }

  void _displayAddConnectionToFollowsListsBottomSheet() async {
    if (widget.onWillShowModalBottomSheet != null)
      widget.onWillShowModalBottomSheet();

    var initialPickedLists = widget.user.followLists?.lists;

    bool hasFollowLists = widget.user.hasFollowLists();

    var pickedFollowsLists = await _bottomSheetService.showFollowsListsPicker(
        context: context,
        title: hasFollowLists ? 'Update lists': 'Add account to list',
        actionLabel: hasFollowLists ? 'Save': 'Done',
        initialPickedFollowsLists: initialPickedLists);

    if (pickedFollowsLists != null)
      _onWantsToFollowUserInLists(pickedFollowsLists);
  }

  Future _onWantsToFollowUserInLists(List<FollowsList> followsLists) async {
    await _connectUserInFollowsLists(followsLists);
  }

  Future _connectUserInFollowsLists(List<FollowsList> followsLists) async {
    bool isAlreadyFollowingUser = widget.user.isFollowing;

    try {
      await (isAlreadyFollowingUser
          ? _userService.updateFollowWithUsername(widget.user.username,
              followsLists: followsLists)
          : _userService.followUserWithUsername(widget.user.username,
              followsLists: followsLists));
      if (!isAlreadyFollowingUser) {
        widget.user.incrementFollowersCount();
      }
      _toastService.success(message: 'Success', context: context);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
