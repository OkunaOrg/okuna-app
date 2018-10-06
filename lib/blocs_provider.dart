import 'package:Openbook/pages/auth/create_account/create_account_bloc.dart';
import 'package:flutter/material.dart';

class OpenbookBlocsProvider extends InheritedWidget {
  CreateAccountBloc createAccountBloc = CreateAccountBloc();

  OpenbookBlocsProvider(child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static OpenbookBlocsProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(OpenbookBlocsProvider);
  }
}
