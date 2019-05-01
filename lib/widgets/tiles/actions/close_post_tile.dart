import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBClosePostTile extends StatefulWidget {
  final Post post;
  final VoidCallback onClosePost;
  final VoidCallback onOpenPost;

  const OBClosePostTile({
    Key key,
    @required this.post,
    this.onClosePost,
    this.onOpenPost,
  }) : super(key: key);

  @override
  OBClosePostTileState createState() {
    return OBClosePostTileState();
  }
}

class OBClosePostTileState extends State<OBClosePostTile> {
  UserService _userService;
  ToastService _toastService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        bool isPostClosed = post.isClosed;

        return OBLoadingTile(
          isLoading: _requestInProgress,
          leading: OBIcon(isPostClosed ? OBIcons.openPost : OBIcons.closePost),
          title: OBText(isPostClosed
              ? 'Open post to community'
              : 'Close post from community'),
          onTap: isPostClosed ? _openPost : _closePost,
        );
      },
    );
  }

  void _openPost() async {
    _setRequestInProgress(true);
    try {
      await _userService.openPost(widget.post);
      if (widget.onClosePost != null) widget.onClosePost();
      _toastService.success(message: 'Post is now open to community', context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _closePost() async {
    _setRequestInProgress(true);
    try {
      await _userService.closePost(widget.post);
      if (widget.onOpenPost != null) widget.onOpenPost();
      _toastService.info(message: 'Post is now closed to community, owner can still comment', context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
