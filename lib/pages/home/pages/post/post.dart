import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/post/post.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBPostPage extends StatefulWidget {
  final Post post;

  OBPostPage(this.post);

  @override
  State<OBPostPage> createState() {
    return OBPostPageState();
  }
}

class OBPostPageState extends State<OBPostPage> {
  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'Post',
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: <Widget>[
                        StreamBuilder(
                            stream: widget.post.updateSubject,
                            builder: _buildPost)
                      ],
                    ),
                    onRefresh: _refreshPost),
              ),
            ],
          ),
        ));
  }

  Widget _buildPost(BuildContext context, AsyncSnapshot<Post> snapshot) {
    Post latestPost = snapshot.data;
    if (latestPost == null) return const SizedBox();

    return OBPost(
      latestPost,
      onPostDeleted: _onPostDeleted,
    );
  }

  void _onPostDeleted(Post post) {
    Navigator.pop(context);
  }

  void _bootstrap() async {
    await _refreshPost();
  }

  Future<void> _refreshPost() async {
    try {
      // This will trigger the updateSubject of the post
      await _userService.getPostWithUuid(widget.post.uuid);
    } catch (error) {
      _onError(error);
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
}
