import 'dart:async';
import 'dart:io';

import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/bottom_sheet.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/buttons/success_button.dart';
import 'package:Openbook/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class OBAuthAvatarStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthAvatarStepPageState();
  }
}

class OBAuthAvatarStepPageState extends State<OBAuthAvatarStepPage> {
  File _postImage;

  CreateAccountBloc _createAccountBloc;
  LocalizationService _localizationService;
  BottomSheetService _bottomSheetService;


  @override
  void initState() {
    _postImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _createAccountBloc = openbookProvider.createAccountBloc;
    _bottomSheetService = openbookProvider.bottomSheetService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildWhatYourAvatar(context: context),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildAvatarPicker(context),
                  ],
                ))),
      ),
      backgroundColor: Color(0xFFFFBF39),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    String buttonText = _localizationService.trans('AUTH.CREATE_ACC.NEXT');

    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/legal_age_step');
      },
    );
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText = _localizationService.trans('AUTH.CREATE_ACC.PREVIOUS');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildWhatYourAvatar({@required BuildContext context}) {
    String whatAvatarText =
        _localizationService.trans('AUTH.CREATE_ACC.WHAT_AVATAR');

    return Column(
      children: <Widget>[
        Text(whatAvatarText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  void _setPostImage(File image) {

    setState(() {
      _postImage = image;
      _createAccountBloc.setAvatar(image);
    });
  }

  Widget _buildAvatarPicker(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        File pickedPhoto =
        await _getUserCroppedImage(await _bottomSheetService.showPhotoPicker(context: context));
        if (pickedPhoto != null) _setPostImage(pickedPhoto);
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),

            /// For some reason the image taken with the camera overflows the container while
            /// the asset one doesnt. ClipRRect fixes this.
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: _getUserImage()
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Tap to change',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          )
        ],
      ),
    );
  }

  Image _getUserImage() {
    if (_postImage == null) {
      return Image.asset('assets/images/avatar.jpg');
    }

    return Image.file(_postImage, fit: BoxFit.fill);
  }

  Future<File> _getUserCroppedImage(File image) async {
    if (image == null) {
      return null;
    }

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 500,
      maxHeight: 500,
    );

    return croppedFile;
  }
}
