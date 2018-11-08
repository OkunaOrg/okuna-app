import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/avatars/logged-in-user-avatar.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:Openbook/widgets/buttons/pill-button.dart';
import 'package:Openbook/widgets/buttons/primary-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatePostModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreatePostModalState();
  }
}

class CreatePostModalState extends State<CreatePostModal> {
  TextEditingController textController;
  bool maxCharactersReached;
  int charactersCount;
  String textFeedback;
  GlobalKey<FormState> formKey;

  static const int MAX_ALLOWED_CHARACTERS =
      ValidationService.MAX_ALLOWED_POST_TEXT_CHARACTERS;

  UserService _userService;
  ValidationService _validationService;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.addListener(_onPostTextChanged);
    charactersCount = 0;
    maxCharactersReached = false;
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    textController.removeListener(_onPostTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _validationService = openbookProvider.validationService;

    return Material(
      child: CupertinoPageScaffold(
          navigationBar: _buildNavigationBar(),
          child: SafeArea(
              child: Container(
                  child: Column(
            children: <Widget>[_buildNewPostContent(), _buildPostActions()],
          )))),
    );
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
      middle: Text('New post'),
      trailing: OBPrimaryButton(
        isSmall: true,
        onPressed: () {},
        child: Text('Share'),
      ),
    );
  }

  Widget _buildNewPostContent() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoggedInUserAvatar(
            size: UserAvatarSize.medium,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: textController,
                    validator: _validatePostText,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(color: Colors.black87, fontSize: 18.0),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What\'s going on?'),
                    autocorrect: true,
                  ),
                )),
          )
        ],
      ),
    ));
  }

  Widget _buildPostActions() {
    double actionIconHeight = 20.0;
    double actionSpacing = 10.0;

    return Container(
      height: 51.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Color.fromARGB(3, 0, 0, 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: actionSpacing,
          ),
          OBPillButton(
            text: 'Media',
            hexColor: '#FCC14B',
            icon: Image.asset(
              'assets/images/icons/media-icon.png',
              height: actionIconHeight,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: actionSpacing,
          ),
          OBPillButton(
            text: 'GIF',
            hexColor: '#0F0F0F',
            icon: Image.asset(
              'assets/images/icons/gif-icon.png',
              height: actionIconHeight,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: actionSpacing,
          ),
          OBPillButton(
            text: 'Audience',
            hexColor: '#80E37A',
            icon: Image.asset(
              'assets/images/icons/audience-icon.png',
              height: actionIconHeight,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: actionSpacing,
          ),
          OBPillButton(
            text: 'Burner',
            hexColor: '#F13A59',
            icon: Image.asset(
              'assets/images/icons/burner-icon.png',
              height: actionIconHeight,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: actionSpacing,
          ),
        ],
      ),
    );
  }

  void _onPostTextChanged() {
    String text = textController.text;
    int textLength = text.length;
    if(text != null && textLength > 0){
      charactersCount = text.length;
      maxCharactersReached = charactersCount > MAX_ALLOWED_CHARACTERS;
      print(text);
      _validateForm();
    }
  }

  String _validatePostText(String value) {
    if (!_validationService.isPostTextAllowedLength(value)) {
      var errorMsg =
          'Post cannot be longer than $MAX_ALLOWED_CHARACTERS characters';
      return errorMsg;
    }
  }

  bool _validateForm() {
    return formKey.currentState.validate();
  }
}
