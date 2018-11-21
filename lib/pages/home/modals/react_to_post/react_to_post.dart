import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/emoji_group_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/pages/home/modals/react_to_post/widgets/emoji_groups/emoji_groups.dart';
import 'package:Openbook/pages/home/modals/react_to_post/widgets/emoji_search_bar.dart';
import 'package:Openbook/pages/home/modals/react_to_post/widgets/emoji_search_results.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReactToPostModal extends StatefulWidget {
  OnPostCreatedCallback onReactedToPost;
  Post post;

  OBReactToPostModal(this.post, {this.onReactedToPost});

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostModalState();
  }
}

class OBReactToPostModalState extends State<OBReactToPostModal> {
  UserService _userService;
  ToastService _toastService;

  bool _isReactToPostInProgress;
  bool _needsBootstrap;
  bool _hasSearch;

  GlobalKey<ScaffoldState> _scaffoldKey;

  List<EmojiGroup> _emojiGroups;
  List<Emoji> _allEmojis;
  List<Emoji> _emojiSearchResults;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _emojiGroups = [];
    _emojiSearchResults = [];
    _needsBootstrap = true;
    _hasSearch = false;
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

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: _buildNavigationBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            OBEmojiSearchBar(
              onSearch: _onSearch,
            ),
            Expanded(
                child: _hasSearch
                    ? OBEmojiSearchResults(_emojiSearchResults)
                    : OBEmojiGroups(
                        _emojiGroups,
                        onEmojiPressed: _onEmojiPressed,
                      ))
          ],
        ));
  }

  Widget _buildNavigationBar() {
    return CupertinoNavigationBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          child: Icon(Icons.close, color: Colors.black87),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        middle: Text('React to post'));
  }

  Future<void> reactToPost(Emoji emoji) async {
    _setReactToPostInProgress(true);

    try {
      PostReaction createdPost =
          await _userService.reactToPost(post: widget.post, emoji: emoji);
      // Remove modal
      Navigator.pop(context);
      if (widget.onReactedToPost != null) widget.onReactedToPost(createdPost);
    } on HttpieConnectionRefusedError {
      _toastService.error(
          scaffoldKey: _scaffoldKey, message: 'No internet connection');
      _setReactToPostInProgress(false);
    } catch (e) {
      _toastService.error(scaffoldKey: _scaffoldKey, message: 'Unknown error.');
      _setReactToPostInProgress(false);
      rethrow;
    }
  }

  void _onEmojiPressed(Emoji pressedEmoji) {
    print(pressedEmoji.keyword);
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

  void _setReactToPostInProgress(bool reactToPostInProgress) {
    setState(() {
      _isReactToPostInProgress = reactToPostInProgress;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }
}

typedef void OnPostCreatedCallback(PostReaction reaction);
