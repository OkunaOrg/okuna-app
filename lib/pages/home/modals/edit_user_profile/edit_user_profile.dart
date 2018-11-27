import 'package:Openbook/models/user.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBEditUserProfileModal extends StatefulWidget {
  final User user;

  OBEditUserProfileModal(this.user);

  @override
  OBEditUserProfileModalState createState() {
    return OBEditUserProfileModalState();
  }
}

class OBEditUserProfileModalState extends State<OBEditUserProfileModal> {
  bool _requestInProgress;

  @override
  void initState() {
    _requestInProgress = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildNavigationBar(),
        body: Container(
            child: Column(
          children: <Widget>[],
        )));
  }

  Widget _buildNavigationBar() {
    bool newPostButtonIsEnabled = true;

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
        isDisabled: !newPostButtonIsEnabled,
        isLoading: _requestInProgress,
        isSmall: true,
        onPressed: _saveUser,
        child: Text('Share'),
      ),
    );
  }

  void _saveUser() {}

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
