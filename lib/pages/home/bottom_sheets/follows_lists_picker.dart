import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/follows_lists_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/modal_service.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/follows_lists_horizontal_list/follows_lists_horizontal_list.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBFollowsListsPickerBottomSheet extends StatefulWidget {
  final String title;
  final String actionLabel;
  final List<FollowsList> initialPickedFollowsLists;

  const OBFollowsListsPickerBottomSheet(
      {Key key,
      this.initialPickedFollowsLists,
      @required this.title,
      @required this.actionLabel})
      : super(key: key);

  @override
  OBFollowsListsPickerBottomSheetState createState() {
    return OBFollowsListsPickerBottomSheetState();
  }
}

class OBFollowsListsPickerBottomSheetState
    extends State<OBFollowsListsPickerBottomSheet> {
  UserService _userService;
  ModalService _modalService;

  bool _needsBootstrap;

  List<FollowsList> _followsLists;
  List<FollowsList> _followsListSearchResults;
  List<FollowsList> _pickedFollowsLists;

  @override
  void initState() {
    super.initState();
    _followsLists = [];
    _followsListSearchResults = [];
    _pickedFollowsLists = widget.initialPickedFollowsLists != null
        ? widget.initialPickedFollowsLists.toList()
        : [];
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _modalService = openbookProvider.modalService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OBText(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                OBButton(
                    size: OBButtonSize.small,
                    child: Text(widget.actionLabel),
                    onPressed: () async {
                      Navigator.pop(context, _pickedFollowsLists);
                    }),
              ],
            ),
          ),
          OBSearchBar(
            onSearch: _onSearch,
            hintText: 'Search lists...',
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 110,
            child: OBFollowsListsHorizontalList(
              _followsListSearchResults,
              previouslySelectedFollowsLists: widget.initialPickedFollowsLists,
              selectedFollowsLists: _pickedFollowsLists,
              onFollowsListPressed: _onFollowsListPressed,
              onWantsToCreateANewFollowsList: _onWantsToCreateANewFollowsList,
            ),
          )
        ],
      ),
    );
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _resetFollowsListSearchResults();
      return;
    }

    String standarisedSearchStr = searchString.toLowerCase();

    List<FollowsList> results = _followsLists.where((FollowsList followsList) {
      return followsList.name.toLowerCase().contains(standarisedSearchStr);
    }).toList();

    _setFollowsListSearchResults(results);
  }

  void _setFollowsListSearchResults(
      List<FollowsList> followsListSearchResults) {
    setState(() {
      _followsListSearchResults = followsListSearchResults;
    });
  }

  void _onWantsToCreateANewFollowsList() async {
    FollowsList createdFollowsList =
        await _modalService.openCreateFollowsList(context: context);
    if (createdFollowsList != null) {
      _addFollowsList(createdFollowsList);
      _addSelectedFollowsList(createdFollowsList);
    }
  }

  void _onFollowsListPressed(FollowsList pressedFollowsList) {
    if (_pickedFollowsLists.contains(pressedFollowsList)) {
      // Remove
      _removeSelectedFollowsList(pressedFollowsList);
    } else {
      // Add
      _addSelectedFollowsList(pressedFollowsList);
    }
  }

  void _resetFollowsListSearchResults() {
    setState(() {
      _followsListSearchResults = _followsLists.toList();
    });
  }

  void _bootstrap() async {
    FollowsListsList followsListList = await _userService.getFollowsLists();
    var connectionsFollowsLists = followsListList.lists;
    this._setFollowsLists(connectionsFollowsLists);
  }

  void _addFollowsList(FollowsList followsList) {
    setState(() {
      _followsLists.add(followsList);
    });
  }

  void _setFollowsLists(List<FollowsList> followsLists) {
    setState(() {
      _followsLists = followsLists;
      _followsListSearchResults = followsLists.toList();
      _pickedFollowsLists.removeWhere((FollowsList followsList) {
        return !followsLists.contains(followsList);
      });
    });
  }

  void _addSelectedFollowsList(FollowsList followsList) {
    setState(() {
      _pickedFollowsLists.add(followsList);
    });
  }

  void _removeSelectedFollowsList(FollowsList followsList) {
    setState(() {
      _pickedFollowsLists.remove(followsList);
    });
  }
}

typedef Future<void> OnPickedFollowsLists(List<FollowsList> followsLists);
