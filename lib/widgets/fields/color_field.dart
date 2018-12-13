import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBColorField extends StatefulWidget {
  final String initialColor;
  final String subtitle;
  final String labelText;
  final String hintText;
  final OnNewColor onNewColor;

  const OBColorField(
      {Key key,
      this.initialColor,
      this.subtitle,
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
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _color = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    _themeService = OpenbookProvider.of(context).themeService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

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
                  color:
                      _color == null ? SizedBox() : Pigment.fromString(_color),
                ),
                height: 30,
                width: 30,
              ),
              onTap: _refreshColor),
        ),
        OBDivider(),
      ],
    );
  }

  void _bootstrap() {
    if (_color == null) {
      _refreshColor();
    }
  }

  void _refreshColor() {
    setState(() {
      _color = generateRandomColor();
      widget.onNewColor(_color);
    });
  }

  String generateRandomColor() {
    return _themeService.generateRandomHexColor();
  }
}

typedef void OnNewColor(String color);
