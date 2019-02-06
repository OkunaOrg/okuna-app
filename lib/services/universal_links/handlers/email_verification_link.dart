import 'dart:async';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/auth_api.dart';
import 'package:Openbook/services/httpie.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/universal_links/universal_links.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/material.dart';

class EmailVerificationLinkHandler extends UniversalLinkHandler {
  static const String verifyEmailLink = '/api/auth/email/verify';
  StreamSubscription _onLoggedInUserChangeSubscription;

  @override
  Future handle({BuildContext context, String link}) async{
    if (link.indexOf(verifyEmailLink) != -1) {
      final token = _getEmailVerificationTokenFromLink(link);
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      UserService userService = openbookProvider.userService;
      ToastService toastService = openbookProvider.toastService;
      AuthApiService authApiService = openbookProvider.authApiService;

      _onLoggedInUserChangeSubscription =
          userService.loggedInUserChange.listen((User newUser) async {
        _onLoggedInUserChangeSubscription.cancel();

        try {
          HttpieResponse response =
              await authApiService.verifyEmailWithToken(token);
          if (response.isOk()) {
            toastService.success(
                message: 'Awesome! Your email is now verified', context: context);
          } else if (response.isUnauthorized()) {
            toastService.error(
                message:
                'Oops! Your token was not valid or expired, please try again',
                context: context);
          }
        } on HttpieConnectionRefusedError {
          toastService.error(message: 'No internet connection', context: null);
        } catch (e) {
          toastService.error(message: 'Unknown error.', context: null);
          rethrow;
        }
      });
    }
  }

  String _getEmailVerificationTokenFromLink(String link) {
    final linkParts = _getDeepLinkParts(link);
    return linkParts[linkParts.length - 1];
  }

  List<String> _getDeepLinkParts(String link) {
    final uri = Uri.parse(link);
    return uri.path.split('/');
  }
}
