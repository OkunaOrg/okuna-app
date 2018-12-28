import 'package:flutter/material.dart';

class OBFadeInMaterialPageRoute<T> extends MaterialPageRoute<T> {
  OBFadeInMaterialPageRoute({ WidgetBuilder builder, RouteSettings settings, bool fullscreenDialog })
      : super(builder: builder, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}