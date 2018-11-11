import 'package:Openbook/widgets/icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

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

/*    var toast = Flushbar(
      title: title,
      message: message,
      duration: toastDuration,
      backgroundColor: backgroundColor,
      //borderRadius: 500.0,
      //aroundPadding: 60.0,
      flushbarPosition: FlushbarPosition.BOTTOM,
    );

    toast.show(context);

    */
  }
}
