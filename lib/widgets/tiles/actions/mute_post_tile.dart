import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMutePostTile extends StatefulWidget {
  final Post post;
  final VoidCallback onMutedPost;
  final VoidCallback onUnmutedPost;

  const OBMutePostTile({
    Key key,
    @required this.post,
    this.onMutedPost,
    this.onUnmutedPost,
  }) : super(key: key);

  @override
  OBMutePostTileState createState() {
    return OBMutePostTileState();
  }
}

class OBMutePostTileState extends State<OBMutePostTile> {
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
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;
        if (post == null) return const SizedBox();

        bool isMuted = post.isMuted;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(isMuted ? OBIcons.unmutePost : OBIcons.mutePost),
          title: OBText(isMuted
              ? 'Unmute post notifications'
              : 'Mute post notifications'),
          onTap: isMuted ? _unmutePost : _mutePost,
        );
      },
    );
  }

  void _mutePost() async {
    _setRequestInProgress(true);
    try {
      await _userService.mutePost(widget.post);
      if (widget.onMutedPost != null) widget.onMutedPost();
    } catch (e) {
      _onRequestError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unmutePost() async {
    _setRequestInProgress(true);
    try {
      await _userService.unmutePost(widget.post);
      if (widget.onUnmutedPost != null) widget.onUnmutedPost();
    } catch (e) {
      _onRequestError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onRequestError(e) {
    if (e is HttpieConnectionRefusedError) {
      _toastService.error(message: 'No internet connection', context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
    }
    throw e;
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
