import 'package:Openbook/delegates/localization_delegate.dart';
import 'package:Openbook/pages/auth/create_account/birthday_step.dart';
import 'package:Openbook/pages/auth/create_account/get_started.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/pages/auth/create_account/name_step.dart';
import 'package:Openbook/pages/auth/create_account/username_step.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/validation.dart';
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
          '/': (BuildContext context) {

            // I'm not sure where to do this otherwise.
            // This block MUST be executed before loading any route.
            var localizationService = LocalizationService.of(context);
            var validationService = ValidationService();

            var openbookBlocsProvider = OpenbookProvider.of(context);
            openbookBlocsProvider.setLocalizationService(localizationService);
            openbookBlocsProvider.setValidationService(validationService);

            return AuthSplashPage();
          },
          '/auth/get-started': (BuildContext context) => AuthGetStartedPage(),
          '/auth/birthday_step': (BuildContext context) =>
              AuthBirthdayStepPage(),
          '/auth/name_step': (BuildContext context) => AuthNameStepPage(),
          '/auth/username_step': (BuildContext context) =>
              AuthUsernameStepPage(),
        }));
  }
}
