import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/emoji_picker/emoji_picker.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
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
        key: _scaffoldKey,
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
          child: OBEmojiPicker(
            isReactionsPicker: true,
            onEmojiPicked: _onEmojiPicked,
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
        leading: GestureDetector(
          child: OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: 'React to post');
  }

  void _onEmojiPicked(Emoji pressedEmoji, EmojiGroup emojiGroup) {
    _reactToPost(pressedEmoji, emojiGroup);
  }

  Future<PostReaction> _reactToPost(Emoji emoji, EmojiGroup emojiGroup) async {
    if (_isReactToPostInProgress) return null;
    _setReactToPostInProgress(true);

    try {
      PostReaction postReaction = await _userService.reactToPost(
          post: widget.post, emoji: emoji, emojiGroup: emojiGroup);
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
