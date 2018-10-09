import 'package:Openbook/delegates/localization_delegate.dart';
import 'package:Openbook/pages/auth/create_account/avatar_step.dart';
import 'package:Openbook/pages/auth/create_account/birthday_step.dart';
import 'package:Openbook/pages/auth/create_account/email_step.dart';
import 'package:Openbook/pages/auth/create_account/get_started.dart';
import 'package:Openbook/pages/auth/create_account/submit_step.dart';
import 'package:Openbook/pages/auth/create_account/password_step.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/name_step.dart';
import 'package:Openbook/pages/auth/create_account/username_step.dart';
import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/pages/auth/splash.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';

//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  //debugPaintBaselinesEnabled = true;
  //debugPaintPointersEnabled = true;
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OpenbookProvider(MaterialApp(
      title: 'Openbook',
      supportedLocales: [const Locale('es', 'ES'), const Locale('en', 'US')],
      localizationsDelegates: [
        const LocalizationServiceDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
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
          return AuthSplashPage();
        },
        '/auth/get-started': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthGetStartedPage();
        },
        '/auth/birthday_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthBirthdayStepPage();
        },
        '/auth/name_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthNameStepPage();
        },
        '/auth/username_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthUsernameStepPage();
        },
        '/auth/email_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthEmailStepPage();
        },
        '/auth/password_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthPasswordStepPage();
        },
        '/auth/avatar_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthAvatarStepPage();
        },
        '/auth/submit_step': (BuildContext context) {
          bootstrapOpenbookProviderInContext(context);
          return AuthSubmitPage();
        }
      },
    ));
  }
}

void bootstrapOpenbookProviderInContext(BuildContext context) {
  var openbookProvider = OpenbookProvider.of(context);
  var localizationService = LocalizationService.of(context);
  openbookProvider.setLocalizationService(localizationService);
}
