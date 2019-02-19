import 'package:Openbook/models/category.dart';
import 'package:Openbook/widgets/categories_picker.dart';
import 'package:Openbook/widgets/theming/divider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCategoriesField extends StatefulWidget {
  final OBCategoriesFieldController controller;
  final String title;
  final int max;
  final int min;
  final bool displayErrors;
  final ValueChanged<List<Category>> onChanged;

  const OBCategoriesField(
      {Key key,
      this.controller,
      @required this.title,
      @required this.max,
      @required this.min,
      @required this.onChanged,
      this.displayErrors = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBCategoriesFieldState();
  }
}

class OBCategoriesFieldState extends State<OBCategoriesField> {
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller.attach(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    int max = widget.max;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBText(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OBText('Pick up to $max categories'),
            ),
          ),
          OBCategoriesPicker(
            maxSelections: widget.max,
            onChanged: _onCategoriesChanged,
          ),
          widget.displayErrors && !_isValid
              ? _buildErrorMsg()
              : const SizedBox(
                  height: 20,
                ),
          OBDivider()
        ]);
  }

  Widget _buildErrorMsg() {
    int min = widget.min;
    String errorMsg = 'You must pick at least $min ' +
        (min == 1 ? 'category.' : 'categories.');

    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 20),
      child: OBText(
        errorMsg,
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }

  void _onCategoriesChanged(List<Category> categories) {
    int min = widget.min;
    if (categories.length < min) {
      _setIsValid(false);
    } else {
      _setIsValid(true);
    }
    widget.onChanged(categories);
  }

  void _setIsValid(bool isValid) {
    setState(() {
      this._isValid = isValid;
    });
  }
}

class OBCategoriesFieldController {
  OBCategoriesFieldState _state;

  void attach(OBCategoriesFieldState state) {
    _state = state;
  }

  bool isValid() {
    return _state == null ? false : _state._isValid;
  }
}
