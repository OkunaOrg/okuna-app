import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/models/emoji_group.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/emoji_picker/emoji_picker.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum OBReactToPostModalStatus { searching, suggesting, overview }

class OBReactToPostBottomSheet extends StatefulWidget {
  final Post post;

  const OBReactToPostBottomSheet(this.post);

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostBottomSheetState();
  }
}

class OBReactToPostBottomSheetState extends State<OBReactToPostBottomSheet> {
  UserService _userService;
  ToastService _toastService;

  bool _isReactToPostInProgress;

  @override
  void initState() {
    super.initState();
    _isReactToPostInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    double screenHeight = MediaQuery.of(context).size.height;

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: screenHeight / 3,
            child: OBEmojiPicker(
              hasSearch: false,
              isReactionsPicker: true,
              onEmojiPicked: _onEmojiPicked,
            ),
          )
        ],
      ),
    );
  }

  void _onEmojiPicked(Emoji pressedEmoji, EmojiGroup emojiGroup) {
    _reactToPost(pressedEmoji, emojiGroup);
  }

  Future<void> _reactToPost(Emoji emoji, EmojiGroup emojiGroup) async {
    if (_isReactToPostInProgress) return null;
    _setReactToPostInProgress(true);

    try {
      PostReaction postReaction = await _userService.reactToPost(
          post: widget.post, emoji: emoji, emojiGroup: emojiGroup);
      widget.post.setReaction(postReaction);
      // Remove modal
      Navigator.pop(context);
    } catch (error) {
      _onError(error);
    } finally {
      _setReactToPostInProgress(false);
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setReactToPostInProgress(bool reactToPostInProgress) {
    setState(() {
      _isReactToPostInProgress = reactToPostInProgress;
    });
  }
}

typedef void OnPostCreatedCallback(PostReaction reaction);
