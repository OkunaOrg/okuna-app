import 'package:Openbook/widgets/icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum ToastType { info, warning, success, error }

class ToastService {
  static const Duration toastDuration = Duration(seconds: 3);

  void info(
      {String title,
      @required String message,
      @required BuildContext context}) {
    toast(
        title: title, message: message, context: context, type: ToastType.info);
  }

  void warning(
      {String title,
      @required String message,
      @required BuildContext context}) {
    toast(
        title: title,
        message: message,
        context: context,
        type: ToastType.warning);
  }

  void success(
      {String title,
      @required String message,
      @required BuildContext context}) {
    toast(
        title: title,
        message: message,
        context: context,
        type: ToastType.success);
  }

  void error(
      {String title,
      @required String message,
      @required BuildContext context}) {
    toast(
        title: title,
        message: message,
        context: context,
        type: ToastType.error);
  }

  void toast(
      {String title,
      @required String message,
      @required BuildContext context,
      @required ToastType type}) {
    Widget icon;


    switch (type) {
      case ToastType.warning:
        icon = OBIcon(OBIcons.warning);
        break;
      case ToastType.info:
        icon = OBIcon(OBIcons.info);
        break;
      case ToastType.success:
        icon = OBIcon(OBIcons.success);
        break;
      case ToastType.error:
        icon = OBIcon(OBIcons.error);
        break;
      default:
        throw 'Unsupported ToastType';
    }

    var toast = Flushbar(
      title: title,
      message: message,
      duration: toastDuration
    );

    toast.show(context);
  }
}
