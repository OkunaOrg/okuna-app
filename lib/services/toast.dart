import 'package:Openbook/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ToastType { info, warning, success, error }

class ToastService {
  static const Duration toastDuration = Duration(seconds: 3);
  static Color colorError = Colors.redAccent;
  static Color colorSuccess = Colors.greenAccent[700];
  static Color colorInfo = Colors.blueGrey;
  static Color colorWarning = Colors.yellow[800];

  void warning({
    String title,
    @required String message,
    @required BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    toast(
        title: title,
        message: message,
        type: ToastType.warning,
        context: context,
        scaffoldKey: scaffoldKey);
  }

  void success({
    String title,
    @required String message,
    @required BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    toast(
        title: title,
        message: message,
        type: ToastType.success,
        context: context,
        scaffoldKey: scaffoldKey);
  }

  void error({
    String title,
    @required String message,
    @required BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    toast(
        title: title,
        message: message,
        type: ToastType.error,
        context: context,
        scaffoldKey: scaffoldKey);
  }

  void info({
    String title,
    @required String message,
    @required BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    toast(
        title: title,
        message: message,
        type: ToastType.info,
        context: context,
        scaffoldKey: scaffoldKey);
  }

  void toast({
    String title,
    @required String message,
    @required ToastType type,
    @required BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    print(message);
    if (context != null) {
      OpenbookToast.of(context).showToast(ToastConfig(color: _getToastColor(type), message: message));
    } else {
      print('Context was null, cannot show toast');
    }
  }

  Color _getToastColor(ToastType type) {
    var color;

    switch (type) {
      case ToastType.error:
        color = colorError;
        break;
      case ToastType.info:
        color = colorInfo;
        break;
      case ToastType.success:
        color = colorSuccess;
        break;
      case ToastType.warning:
        color = colorWarning;
        break;
    }

    return color;
  }
}

class ToastConfig {
  final Color color;
  final String message;

  ToastConfig({
    this.color,
    this.message
  });

}
