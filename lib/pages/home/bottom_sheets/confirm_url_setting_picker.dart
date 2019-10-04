import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBConfirmUrlSettingPickerBottomSheet extends StatefulWidget {
  final ValueChanged<bool> onTypeChanged;

  final bool initialValue;

  const OBConfirmUrlSettingPickerBottomSheet(
      {Key key, @required this.onTypeChanged, this.initialValue})
      : super(key: key);

  @override
  OBConfirmUrlSettingPickerBottomSheetState createState() {
    return OBConfirmUrlSettingPickerBottomSheetState();
  }
}

class OBConfirmUrlSettingPickerBottomSheetState
    extends State<OBConfirmUrlSettingPickerBottomSheet> {
  FixedExtentScrollController _cupertinoPickerController;
  List<bool> allValues;

  @override
  void initState() {
    super.initState();
    allValues = [true, false];
    _cupertinoPickerController = FixedExtentScrollController(
      initialItem: widget.initialValue != null
          ? allValues.indexOf(widget.initialValue)
          : 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);

    Map<bool, String> localizationMap = openbookProvider.userPreferencesService
        .getConfirmUrlSettingLocalizationMap();

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          scrollController: _cupertinoPickerController,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            widget.onTypeChanged(allValues[index]);
          },
          itemExtent: 32,
          children: allValues.map((setting) {
            return OBText(localizationMap[setting]);
          }).toList(),
        ),
      ),
    );
  }
}
