import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBFollowsListPage extends StatefulWidget {
  final FollowsList followsList;

  OBFollowsListPage(this.followsList);

  @override
  OBFollowsListPageState createState() {
    return OBFollowsListPageState();
  }
}

class OBFollowsListPageState extends State<OBFollowsListPage> {
  static const double INPUT_ICONS_SIZE = 16;
  static EdgeInsetsGeometry INPUT_CONTENT_PADDING =
  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  String _takenFollowsListName;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _requestInProgress = false;
    _formWasSubmitted = false;

    _nameController = TextEditingController(text: widget.followsList.name);

    _nameController.addListener(_validateForm);
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _validationService = openbookProvider.validationService;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildNavigationBar(),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    validator: (String followsListName) {
                      if (!_formWasSubmitted) return null;
                      if (_takenFollowsListName != null &&
                          _takenFollowsListName == followsListName)
                        return 'FollowsListName @$_takenFollowsListName is taken';
                      //return _validationService.validateUserFollowsListName(followsListName);
                    },
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      labelText: 'FollowsListName',
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        size: INPUT_ICONS_SIZE,
                      ),
                    ),
                  ),
                  Divider(),
                ],
              )),
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
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text('Save'),
      ),
    );
  }

  void _showImageBottomSheet({@required OBImageType imageType}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> listTiles = [
            new ListTile(
              leading: new Icon(Icons.camera_alt),
              title: new Text('Camera'),
              onTap: () async {},
            ),
            new ListTile(
              leading: new Icon(Icons.photo_library),
              title: new Text('Gallery'),
              onTap: () async {},
            )
          ];
          return Column(mainAxisSize: MainAxisSize.min, children: listTiles);
        });
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void _submitForm() async {
    _formWasSubmitted = true;
    _setRequestInProgress(true);
    try {
      var followsListName = _nameController.text;
      bool followsListNameTaken =
      await _isFollowsListNameTaken(followsListName);
      if (followsListNameTaken) {
        _setTakenFollowsListName(followsListName);
        _validateForm();
        return;
      }

      await _userService.createFollowsList(name: _nameController.text);
      Navigator.of(context).pop();
    } on HttpieConnectionRefusedError {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (e) {
      _toastService.error(message: 'Unknown error.', context: context);
      rethrow;
    } finally {
      _setRequestInProgress(false);
    }
  }

  Future<bool> _isFollowsListNameTaken(String followsListName) async {
    if (followsListName == widget.followsList.name) return false;
    return false;
    //return _validationService.isFollowsListNameTaken(followsListName);
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setTakenFollowsListName(String takenFollowsListName) {
    setState(() {
      _takenFollowsListName = takenFollowsListName;
    });
  }
}
