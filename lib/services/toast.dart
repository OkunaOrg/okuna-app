import 'package:flutter/material.dart';

enum ToastType { info, warning, success, error }

class ToastService {
  static const Duration toastDuration = Duration(seconds: 3);

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
  }
}
