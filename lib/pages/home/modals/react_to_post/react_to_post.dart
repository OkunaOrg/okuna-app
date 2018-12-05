import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/emoji_picker/emoji_picker.dart';
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

  bool _isReactToPostInProgress;

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _isReactToPostInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: _buildNavigationBar(),
        body: OBEmojiPicker(
          onEmojiPicked: _onEmojiPicked,
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

  void _onEmojiPicked(Emoji pressedEmoji) {
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
      _toastService.error(message: 'No internet connection', context: context);
      _setReactToPostInProgress(false);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      _setReactToPostInProgress(false);
      rethrow;
    }
  }

  void _setReactToPostInProgress(bool reactToPostInProgress) {
    setState(() {
      _isReactToPostInProgress = reactToPostInProgress;
    });
  }
}

typedef void OnPostCreatedCallback(PostReaction reaction);
