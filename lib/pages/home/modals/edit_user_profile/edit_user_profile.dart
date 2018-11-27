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
  final _formKey = GlobalKey<FormState>();
  bool _followersCountVisible;

  TextEditingController _usernameController;
  TextEditingController _nameController;
  TextEditingController _urlController;
  TextEditingController _locationController;
  TextEditingController _bioController;

  @override
  void initState() {
    _requestInProgress = false;

    _followersCountVisible = widget.user.getProfileFollowersCountVisible();
    _usernameController = TextEditingController(text: widget.user.username);
    _nameController = TextEditingController(text: widget.user.getProfileName());
    _urlController = TextEditingController(text: widget.user.getProfileUrl());
    _locationController =
        TextEditingController(text: widget.user.getProfileLocation());
    _bioController = TextEditingController(text: widget.user.getProfileBio());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 16;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildNavigationBar(),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Username',
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          size: iconSize,
                        ),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person, size: iconSize),
                        labelText: 'Name',
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.link,
                          size: iconSize,
                        ),
                        labelText: 'Url',
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Location',
                        prefixIcon: Icon(
                          Icons.location_on,
                          size: iconSize,
                        ),
                      ),
                    ),
                    Divider(),
                    TextFormField(
                      controller: _bioController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: 'Bio',
                          prefixIcon: Icon(
                            Icons.bookmark,
                            size: iconSize,
                          ),
                          border: InputBorder.none),
                    ),
                    Divider(),
                    MergeSemantics(
                      child: ListTile(
                        leading: Icon(Icons.supervisor_account),
                        title: Text('Followers count'),
                        trailing: CupertinoSwitch(
                          value: _followersCountVisible,
                          onChanged: (bool value) {
                            setState(() {
                              _followersCountVisible = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _followersCountVisible = !_followersCountVisible;
                          });
                        },
                      ),
                    ),
                    Divider(),
                  ],
                )),
          ),
        ));
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
      middle: Text('Edit profile'),
      trailing: OBPrimaryButton(
        isDisabled: !newPostButtonIsEnabled,
        isLoading: _requestInProgress,
        isSmall: true,
        onPressed: _saveUser,
        child: Text('Save'),
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
