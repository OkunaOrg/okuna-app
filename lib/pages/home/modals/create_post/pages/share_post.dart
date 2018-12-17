import 'dart:io';
import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_picker/circles_picker.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostPage extends StatefulWidget {
  final SharePostData sharePostData;

  const OBSharePostPage({Key key, @required this.sharePostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostPageState();
  }
}

class OBSharePostPageState extends State<OBSharePostPage> {
  List<Circle> _latestPickedCircles;
  UserService _userService;
  ToastService _toastService;
  bool _isCreatePostInProgress;

  @override
  void initState() {
    super.initState();
    _isCreatePostInProgress = false;
    _latestPickedCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: OBCirclesPicker(
            onPickedCirclesChanged: _onPickedCirclesChanged,
          ),
        ));
  }

  Widget _buildNavigationBar() {
    return OBNavigationBar(
      title: 'Audience',
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isLoading: _isCreatePostInProgress,
        onPressed: createPost,
        child: Text('Share'),
      ),
    );
  }

  void _onPickedCirclesChanged(List<Circle> pickedCircles) {
    _latestPickedCircles = pickedCircles;
    pickedCircles.forEach((circle) => print(circle.name));
  }

  Future<void> createPost() async {
    _setCreatePostInProgress(true);

    try {
      Post createdPost = await _userService.createPost(
          text: widget.sharePostData.text,
          image: widget.sharePostData.image,
          circles: _latestPickedCircles);
      Navigator.pop(context, createdPost);
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setCreatePostInProgress(false);
    }
  }

  void _setCreatePostInProgress(bool createPostInProgress) {
    setState(() {
      _isCreatePostInProgress = createPostInProgress;
    });
  }
}

class SharePostData {
  String text;
  File image;

  SharePostData({@required this.text, @required this.image});
}
