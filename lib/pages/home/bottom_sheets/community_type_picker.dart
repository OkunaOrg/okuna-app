import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// The sheet is stateful as there is a stupid bug that makes CupertinoPicker
// pretty much useless without the bootstrap hack
// https://github.com/flutter/flutter/issues/28109

class OBCommunityTypePickerBottomSheet extends StatefulWidget {
  final ValueChanged<CommunityType> onTypeChanged;

  // Useless for now given the bug
  final CommunityType initialType;

  const OBCommunityTypePickerBottomSheet(
      {Key key, @required this.onTypeChanged, CommunityType this.initialType})
      : super(key: key);

  @override
  OBCommunityTypePickerBottomSheetState createState() {
    return OBCommunityTypePickerBottomSheetState();
  }
}

class OBCommunityTypePickerBottomSheetState
    extends State<OBCommunityTypePickerBottomSheet> {
  bool _needsBootstrap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {

    // Hack.
    if (_needsBootstrap) {
      Future.delayed(Duration(milliseconds: 0), () {
        widget.onTypeChanged(CommunityType.values[0]);
      });
      _needsBootstrap = false;
    }

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            CommunityType newType = CommunityType.values[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children: <Widget>[OBText('Public'), OBText('Private')],
        ),
      ),
    );
  }
}
