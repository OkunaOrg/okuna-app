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

enum OBReactToPostModalStatus { searching, suggesting, overview }

class OBReactToPostModal extends StatefulWidget {
  Post post;

  OBReactToPostModal(this.post);

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostModalState();
  }
}

class OBReactToPostModalState extends State<OBReactToPostModal> {
  UserService _userService;
  ToastService _toastService;
  OBReactToPostModalStatus _status;

  bool _isReactToPostInProgress;
  bool _needsBootstrap;
  bool _hasSearch;

  GlobalKey<ScaffoldState> _scaffoldKey;

  List<EmojiGroup> _emojiGroups;
  List<Emoji> _allEmojis;
  List<Emoji> _emojiSearchResults;
  String _emojiSearchQuery;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _emojiGroups = [];
    _emojiSearchResults = [];
    _emojiSearchQuery = '';
    _needsBootstrap = true;
    _hasSearch = false;
    _status = OBReactToPostModalStatus.overview;
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
                    ? OBEmojiSearchResults(
                        _emojiSearchResults, _emojiSearchQuery)
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

  void _onEmojiPressed(Emoji pressedEmoji) {
    _reactToPost(pressedEmoji);
  }

  Future<PostReaction> _reactToPost(Emoji emoji) async {
    _setReactToPostInProgress(true);

    try {
      PostReaction postReaction =
          await _userService.reactToPost(post: widget.post, emoji: emoji);
      widget.post.setReaction(postReaction);
      // Remove modal
      Navigator.pop(context);
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
