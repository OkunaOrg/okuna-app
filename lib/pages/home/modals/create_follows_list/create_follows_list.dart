import 'package:Openbook/models/emoji.dart';
import 'package:Openbook/pages/home/modals/create_follows_list/pages/pick_follows_list_icon.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/services/validation.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/primary_button.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:Openbook/widgets/routes/slide_right_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCreateFollowsListModal extends StatefulWidget {
  OBCreateFollowsListModal();

  @override
  OBCreateFollowsListModalState createState() {
    return OBCreateFollowsListModalState();
  }
}

class OBCreateFollowsListModalState extends State<OBCreateFollowsListModal> {
  static const double INPUT_ICONS_SIZE = 16;
  static EdgeInsetsGeometry INPUT_CONTENT_PADDING =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;

  bool _requestInProgress;
  bool _formWasSubmitted;
  bool _formValid;
  String _takenFollowsListName;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;
  Emoji _icon;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _nameController.addListener(_updateFormValid);
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
                          _takenFollowsListName == followsListName) {
                        return 'List name $_takenFollowsListName is taken';
                      }

                      return _validationService
                          .validateFollowsListName(followsListName);
                    },
                    decoration: InputDecoration(
                      contentPadding: INPUT_CONTENT_PADDING,
                      border: InputBorder.none,
                      labelText: 'Name',
                      prefixIcon: Icon(
                        Icons.list,
                        size: INPUT_ICONS_SIZE,
                      ),
                    ),
                  ),
                  Divider(),
                  MergeSemantics(
                    child: ListTile(
                        title: Text('Icon'),
                        trailing:
                            OBFollowsListIcon(followsListIconUrl: _icon?.image),
                        onTap: _onWantsToPickIcon),
                  ),
                  Divider()
                ],
              )),
        ));
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
      middle: Text('New list'),
      trailing: OBPrimaryButton(
        isDisabled: !_formValid,
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text('Save'),
      ),
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  bool _updateFormValid() {
    var formValid = _validateForm();
    _setFormValid(formValid);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;

    var formIsValid = _updateFormValid();

    if (!formIsValid) return;

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
    return _validationService.isFollowsListNameTaken(followsListName);
  }

  void _onWantsToPickIcon() async {
    Emoji pickedIcon = await Navigator.push(
        context,
        OBSlideRightRoute(
            key: Key('obSlidePickFollowsListIconPage'),
            widget: OBPickFollowsListIconPage()));

    if (pickedIcon != null) _onPickedIcon(pickedIcon);
  }

  void _onPickedIcon(Emoji pickedEmoji) {
    _setIcon(pickedEmoji);
  }

  void _setIcon(Emoji icon) {
    setState(() {
      _icon = icon;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }

  void _setTakenFollowsListName(String takenFollowsListName) {
    setState(() {
      _takenFollowsListName = takenFollowsListName;
    });
  }
}
