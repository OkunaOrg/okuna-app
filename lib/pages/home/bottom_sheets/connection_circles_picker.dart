import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/buttons/button.dart';
import 'package:Openbook/widgets/circles_quick_picker.dart/circles_quick_picker.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectionCirclesPickerBottomSheet extends StatefulWidget {
  final String title;
  final String actionLabel;
  final OnPickedCircles onPickedCircles;

  const OBConnectionCirclesPickerBottomSheet(
      {Key key,
      @required this.title,
      @required this.actionLabel,
      @required this.onPickedCircles})
      : super(key: key);

  @override
  OBConnectionCirclesPickerBottomSheetState createState() {
    return OBConnectionCirclesPickerBottomSheetState();
  }
}

class OBConnectionCirclesPickerBottomSheetState
    extends State<OBConnectionCirclesPickerBottomSheet> {
  List<Circle> _pickedConnectionCircles;

  @override
  void initState() {
    super.initState();
    _pickedConnectionCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: OBPrimaryColorContainer(
        mainAxisSize: MainAxisSize.min,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OBText(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OBButton(
                      size: OBButtonSize.small,
                      child: Text(widget.actionLabel),
                      onPressed: () async {
                        await widget.onPickedCircles(_pickedConnectionCircles);
                        Navigator.pop(context);
                      }),
                ],
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OBText(
                          'Circles help you restrict who can see what you share.'),
                    ])),
            OBCirclesQuickPicker(
              onCirclesPicked: (List<Circle> pickedCirles) async {
                _pickedConnectionCircles = pickedCirles;
              },
            )
          ],
        ),
      ),
    );
  }
}

typedef Future<void> OnPickedCircles(List<Circle> circles);
