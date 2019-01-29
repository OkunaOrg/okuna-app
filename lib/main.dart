import 'package:Openbook/delegates/localization_delegate.dart';
import 'package:Openbook/pages/auth/create_account/done_step.dart';
import 'package:Openbook/pages/auth/create_account/email_step.dart';
import 'package:Openbook/pages/auth/create_account/get_started.dart';
import 'package:Openbook/pages/auth/create_account/legal_age_step.dart';
import 'package:Openbook/pages/auth/create_account/submit_step.dart';
import 'package:Openbook/pages/auth/create_account/password_step.dart';
import 'package:Openbook/pages/auth/login.dart';
import 'package:Openbook/pages/auth/splash.dart';
import 'package:Openbook/pages/home/home.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/name_step.dart';
import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool _isRegistrationTokenConsumed = false;
  @override
  Widget build(BuildContext context) {
    return OpenbookProvider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Openbook',
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('es', 'ES'),
          ],
          localizationsDelegates: [
            const LocalizationServiceDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: new ThemeData(
              buttonTheme: ButtonThemeData(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0))),
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
              // counter didn't reset back to zero; the application is not restarted.
              primarySwatch: Colors.grey,
              fontFamily: 'NunitoSans'),
          routes: {
            /// The openbookProvider uses services available in the context
            /// Their connection must be bootstrapped but no other way to execute
            /// something before loading any route, therefore this ugliness.
            '/': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBHomePage();
            },
            '/auth': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthSplashPage();
            },
            '/auth/get-started': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthGetStartedPage();
            },
            '/auth/legal_age_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthLegalAgeStepPage();
            },
            '/auth/name_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthNameStepPage();
            },
            '/auth/email_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthEmailStepPage();
            },
            '/auth/password_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthPasswordStepPage();
            },
            '/auth/submit_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthSubmitPage();
            },
            '/auth/done_step': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthDonePage();
            },
            '/auth/login': (BuildContext context) {
              bootstrapOpenbookProviderInContext(context);
              return OBAuthLoginPage();
            }
          }),
    );
  }

  void checkRegistrationTokenIsPresent(OpenbookProviderState openbookProvider, BuildContext context) {
    var registrationTokenSubscription;
    if (!_isRegistrationTokenConsumed) {
      registrationTokenSubscription = openbookProvider.createAccountBloc.registrationTokenSubject.stream.listen((String token) {
        if (openbookProvider.createAccountBloc.hasToken()) {
          registrationTokenSubscription.cancel();
          _isRegistrationTokenConsumed = true;
          Navigator.pushNamed(context, '/auth/get-started');
        }
      });
    }
  }

  void bootstrapOpenbookProviderInContext(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = LocalizationService.of(context);
    openbookProvider.setLocalizationService(localizationService);
    checkRegistrationTokenIsPresent(openbookProvider, context);
  }
}

void main() {
  runApp(new MyApp());
}
