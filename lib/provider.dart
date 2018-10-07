import 'package:Openbook/pages/auth/create_account/blocs/create_account.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
import 'package:flutter/material.dart';

class OpenbookProvider extends InheritedWidget {
  CreateAccountBloc createAccountBloc = CreateAccountBloc();

  OpenbookProvider(child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  setLocalizationService(LocalizationService localizationService){
    createAccountBloc.setLocalizationService(localizationService);
  }

  setValidationService(ValidationService validationService){
    createAccountBloc.setValidationService(validationService);
  }

  static OpenbookProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(OpenbookProvider);
  }


}
