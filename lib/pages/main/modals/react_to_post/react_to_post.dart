import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/emoji_group_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/pages/main/modals/react_to_post/widgets/emoji-group.dart';
import 'package:Openbook/pages/main/modals/react_to_post/widgets/emoji-search-bar.dart';
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

  GlobalKey<ScaffoldState> _scaffoldKey;

  List<EmojiGroup> _emojiGroups;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _emojiGroups = [];
    _needsBootstrap = true;
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
          children: <Widget>[OBEmojiSearchBar(), _buildEmojiGroups()],
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

  Widget _buildEmojiGroups() {
    return Expanded(
        child: Container(
            child: Column(
                children: _emojiGroups.map((EmojiGroup emojiGroup) {
      return OBEmojiGroup(emojiGroup);
    }).toList())));
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

  void _bootstrap() async {
    EmojiGroupList emojiGroupList = await _userService.getEmojiGroups();
    this._setEmojiGroups(emojiGroupList.emojisGroups);
  }

  void _setEmojiGroups(List<EmojiGroup> emojiGroups) {
    setState(() {
      this._emojiGroups = emojiGroups;
    });
  }

  void _setReactToPostInProgress(bool reactToPostInProgress) {
    setState(() {
      _isReactToPostInProgress = reactToPostInProgress;
    });
  }
}

typedef void OnPostCreatedCallback(PostReaction reaction);
