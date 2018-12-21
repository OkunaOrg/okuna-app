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
  final bool isReactionsPicker;

  OBEmojiPicker({this.onEmojiPicked, this.isReactionsPicker = false});

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
  List<EmojiGroupSearchResults> _emojiSearchResults;
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

  void _onEmojiPressed(Emoji pressedEmoji, EmojiGroup emojiGroup) {
    widget.onEmojiPicked(pressedEmoji, emojiGroup);
  }

  void _onSearch(String searchString) {
    if (searchString.length == 0) {
      _setHasSearch(false);
      return;
    }

    if (!_hasSearch) _setHasSearch(true);

    String standarisedSearchStr = searchString.toLowerCase();

    List<EmojiGroupSearchResults> searchResults =
        _emojiGroups.map((EmojiGroup emojiGroup) {
      List<Emoji> groupEmojis = emojiGroup.getEmojis();
      List<Emoji> groupSearchResults = groupEmojis.where((Emoji emoji) {
        return emoji.keyword.contains(standarisedSearchStr);
      }).toList();
      return EmojiGroupSearchResults(
          group: emojiGroup, searchResults: groupSearchResults);
    }).toList();

    _setEmojiSearchResults(searchResults);
    _setEmojiSearchQuery(searchString);
  }

  void _bootstrap() async {
    EmojiGroupList emojiGroupList = await (widget.isReactionsPicker
        ? _userService.getReactionEmojiGroups()
        : _userService.getEmojiGroups());
    this._setEmojiGroups(emojiGroupList.emojisGroups);
  }

  void _setEmojiGroups(List<EmojiGroup> emojiGroups) {
    setState(() {
      _emojiGroups = emojiGroups;
    });
  }

  void _setEmojiSearchResults(
      List<EmojiGroupSearchResults> emojiSearchResults) {
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

typedef void OnEmojiPicked(Emoji pickedEmoji, EmojiGroup emojiGroup);

class EmojiGroupSearchResults {
  final EmojiGroup group;
  final List<Emoji> searchResults;

  EmojiGroupSearchResults({@required this.group, @required this.searchResults});
}
