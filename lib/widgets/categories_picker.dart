import 'package:Okuna/models/categories_list.dart';
import 'package:Okuna/models/category.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/widgets/category_badge.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCategoriesPicker extends StatefulWidget {
  final List<Category> initialCategories;
  final ValueChanged<List<Category>> onChanged;
  final maxSelections;

  const OBCategoriesPicker(
      {Key key,
      this.initialCategories,
      this.maxSelections,
      @required this.onChanged})
      : super(key: key);

  @override
  OBCategoriesPickerState createState() {
    return OBCategoriesPickerState();
  }
}

class OBCategoriesPickerState extends State<OBCategoriesPicker> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  List<Category> _categories;
  List<Category> _pickedCategories;

  @override
  void initState() {
    super.initState();
    _categories = [];
    _pickedCategories = widget.initialCategories == null
        ? []
        : widget.initialCategories.toList();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        children: _categories.map(_buildCategory).toList());
  }

  void _bootstrap() async {
    _refreshCategories();
  }

  void _refreshCategories() async {
    try {
      CategoriesList categoriesList = await _userService.getCategories();
      _setCategories(categoriesList.categories);
    } catch (error) {
      _onError(error);
    }
  }

  Widget _buildCategory(Category category) {
    return OBCategoryBadge(
      category: category,
      size: OBCategoryBadgeSize.large,
      isEnabled: _pickedCategories.contains(category),
      onPressed: _onCategoryPressed,
    );
  }

  void _onCategoryPressed(Category pressedCategory) {
    if (_pickedCategories.contains(pressedCategory)) {
      // Remove
      _removeSelectedCategory(pressedCategory);
    } else {
      // Add
      if (widget.maxSelections != null &&
          widget.maxSelections == _pickedCategories.length) return;
      _addSelectedCategory(pressedCategory);
    }

    if (widget.onChanged != null) widget.onChanged(_pickedCategories.toList());
  }

  void _addSelectedCategory(Category category) {
    setState(() {
      _pickedCategories.add(category);
    });
  }

  void _removeSelectedCategory(Category category) {
    setState(() {
      _pickedCategories.remove(category);
    });
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }
}
