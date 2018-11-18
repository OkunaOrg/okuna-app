import 'package:Openbook/widgets/icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

enum ToastType { info, warning, success, error }

class ToastService {
  static const Duration toastDuration = Duration(seconds: 3);

  void warning({
    String title,
    @required String message,
    BuildContext context,
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
    BuildContext context,
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
    BuildContext context,
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
    BuildContext context,
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
    BuildContext context,
    GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    Widget icon;
    Color backgroundColor;

    switch (type) {
      case ToastType.warning:
        icon = OBIcon(OBIcons.warning);
        backgroundColor = Pigment.fromString('#EFB500');
        break;
      case ToastType.info:
        icon = OBIcon(OBIcons.info);
        backgroundColor = Pigment.fromString('#008BEF');
        break;
      case ToastType.success:
        icon = OBIcon(OBIcons.success);
        backgroundColor = Pigment.fromString('#7FD421');
        break;
      case ToastType.error:
        icon = OBIcon(OBIcons.error);
        backgroundColor = Pigment.fromString('#D42140');
        break;
      default:
        throw 'Unsupported ToastType';
    }

    print(message);
  }
}
