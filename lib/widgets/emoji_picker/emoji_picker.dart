import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/emoji_group_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_groups/emoji_groups.dart';
import 'package:Openbook/widgets/emoji_picker/widgets/emoji_search_results.dart';
import 'package:Openbook/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBEmojiPicker extends StatefulWidget {
  final OnEmojiPicked onEmojiPicked;

  OBEmojiPicker({this.onEmojiPicked});

  @override
  State<StatefulWidget> createState() {
    return OBEmojiPickerState();
  }
}

class OBEmojiPickerState extends State<OBEmojiPicker> {
  UserService _userService;
  ToastService _toastService;
  OBEmojiPickerStatus _status;

  bool _needsBootstrap;
  bool _hasSearch;

  List<EmojiGroup> _emojiGroups;
  List<Emoji> _allEmojis;
  List<Emoji> _emojiSearchResults;
  String _emojiSearchQuery;

  @override
  void initState() {
    super.initState();
    _emojiGroups = [];
    _emojiSearchResults = [];
    _emojiSearchQuery = '';
    _needsBootstrap = true;
    _hasSearch = false;
    _status = OBEmojiPickerStatus.overview;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: 'Search emojis...',
        ),
        Expanded(
            child: _hasSearch
                ? OBEmojiSearchResults(
                    _emojiSearchResults,
                    _emojiSearchQuery,
                    onEmojiPressed: _onEmojiPressed,
                  )
                : OBEmojiGroups(
                    _emojiGroups,
                    onEmojiPressed: _onEmojiPressed,
                  ))
      ],
    );
  }

  void _onEmojiPressed(Emoji pressedEmoji) {
    widget.onEmojiPicked(pressedEmoji);
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _setHasSearch(false);
      return;
    }

    if (!_hasSearch) _setHasSearch(true);

    String standarisedSearchStr = searchString.toLowerCase();

    List<Emoji> results = _allEmojis.where((Emoji emoji) {
      return emoji.keyword.contains(standarisedSearchStr);
    }).toList();

    _setEmojiSearchResults(results);
    _setEmojiSearchQuery(searchString);
  }

  void _bootstrap() async {
    EmojiGroupList emojiGroupList = await _userService.getEmojiGroups();
    this._setEmojiGroups(emojiGroupList.emojisGroups);
  }

  void _setEmojiGroups(List<EmojiGroup> emojiGroups) {
    setState(() {
      _emojiGroups = emojiGroups;
      List<Emoji> newAllEmojis = [];
      _emojiGroups.forEach((EmojiGroup emojiGroup) {
        newAllEmojis.addAll(emojiGroup.getEmojis());
      });
      _allEmojis = newAllEmojis;
    });
  }

  void _setEmojiSearchResults(List<Emoji> emojiSearchResults) {
    setState(() {
      _emojiSearchResults = emojiSearchResults;
    });
  }

  void _setEmojiSearchQuery(String searchQuery) {
    setState(() {
      _emojiSearchQuery = searchQuery;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }
}

enum OBEmojiPickerStatus { searching, suggesting, overview }

typedef void OnEmojiPicked(Emoji pickedEmoji);
