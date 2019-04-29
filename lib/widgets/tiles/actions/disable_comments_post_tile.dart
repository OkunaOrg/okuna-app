import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBDisableCommentsPostTile extends StatefulWidget {
  final Post post;
  final VoidCallback onDisableComments;
  final VoidCallback onEnableComments;

  const OBDisableCommentsPostTile({
    Key key,
    @required this.post,
    this.onDisableComments,
    this.onEnableComments,
  }) : super(key: key);

  @override
  OBDisableCommentsPostTileState createState() {
    return OBDisableCommentsPostTileState();
  }
}

class OBDisableCommentsPostTileState extends State<OBDisableCommentsPostTile> {
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

        bool areCommentsEnabled = post.areCommentsEnabled;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(areCommentsEnabled ? OBIcons.disableComments : OBIcons.enableComments),
          title: OBText(areCommentsEnabled
              ? 'Disable comments for post'
              : 'Enable comments for post'),
          onTap: areCommentsEnabled ? _disableComments : _enableComments,
        );
      },
    );
  }

  void _enableComments() async {
    _setRequestInProgress(true);
    try {
      await _userService.enableCommentsForPost(widget.post);
      if (widget.onDisableComments != null) widget.onDisableComments();
      _toastService.success(message: 'Comments now enabled for post', context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _disableComments() async {
    _setRequestInProgress(true);
    try {
      await _userService.disableCommentsForPost(widget.post);
      if (widget.onEnableComments != null) widget.onEnableComments();
      _toastService.info(message: 'Comments now disabled for post', context: context);
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
