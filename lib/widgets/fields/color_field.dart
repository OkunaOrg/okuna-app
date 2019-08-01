import 'package:Okuna/provider.dart';
import 'package:Okuna/services/dialog.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/widgets/buttons/button.dart';
import 'package:Okuna/widgets/theming/divider.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBColorField extends StatefulWidget {
  final String initialColor;
  final String labelText;
  final String hintText;
  final OnNewColor onNewColor;

  const OBColorField(
      {Key key,
      this.initialColor,
      this.labelText,
      @required this.onNewColor,
      this.hintText})
      : super(key: key);

  @override
  OBColorFieldState createState() {
    return OBColorFieldState();
  }
}

class OBColorFieldState extends State<OBColorField> {
  String _color;
  ThemeService _themeService;
  DialogService _dialogService;

  @override
  void initState() {
    super.initState();
    _color = widget.initialColor != null
        ? widget.initialColor
        : generateRandomHexColor();
  }

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    _themeService = openbookProvider.themeService;
    _dialogService = openbookProvider.dialogService;

    return Column(
      children: <Widget>[
        MergeSemantics(
          child: ListTile(
              title: OBText(
                widget.labelText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle:
                  widget.hintText != null ? OBText(widget.hintText) : null,
              trailing: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: _color == null
                      ? const SizedBox()
                      : Pigment.fromString(_color),
                ),
                height: 30,
                width: 30,
              ),
              onTap: _pickColor),
        ),
        OBDivider(),
      ],
    );
  }

  void _pickColor() {
    _dialogService.showColorPicker(
        initialColor: Pigment.fromString(_color),
        onColorChanged: _onPickerColor,
        context: context);
  }

  void _onPickerColor(Color color) {
    String hexString = color.value.toRadixString(16);
    hexString = '#' + hexString.substring(2, hexString.length);
    widget.onNewColor('#' + hexString);
    _setColor(hexString);
  }

  void _setColor(String color) {
    setState(() {
      _color = color;
      widget.onNewColor(_color);
    });
  }

  Color generateRandomColor() {
    return Pigment.fromString(generateRandomHexColor());
  }

  String generateRandomHexColor() {
    return _themeService.generateRandomHexColor();
  }
}

typedef void OnNewColor(String color);
