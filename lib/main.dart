import 'dart:io';

import 'package:Okuna/delegates/localization_delegate.dart';
import 'package:Okuna/pages/auth/create_account/create_account.dart';
import 'package:Okuna/pages/auth/create_account/done_step.dart';
import 'package:Okuna/pages/auth/create_account/email_step.dart';
import 'package:Okuna/pages/auth/create_account/guidelines_step.dart';
import 'package:Okuna/pages/auth/reset_password/forgot_password_step.dart';
import 'package:Okuna/pages/auth/create_account/get_started.dart';
import 'package:Okuna/pages/auth/create_account/legal_age_step.dart';
import 'package:Okuna/pages/auth/create_account/submit_step.dart';
import 'package:Okuna/pages/auth/create_account/password_step.dart';
import 'package:Okuna/pages/auth/reset_password/reset_password_success_step.dart';
import 'package:Okuna/pages/auth/reset_password/set_new_password_step.dart';
import 'package:Okuna/pages/auth/reset_password/verify_reset_password_link_step.dart';
import 'package:Okuna/pages/auth/login.dart';
import 'package:Okuna/pages/auth/splash.dart';
import 'package:Okuna/pages/home/home.dart';
import 'package:Okuna/pages/waitlist/subscribe_done_step.dart';
import 'package:Okuna/pages/waitlist/subscribe_email_step.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/pages/auth/create_account/name_step.dart';
import 'package:Okuna/plugins/desktop/error-reporting.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/universal_links/universal_links.dart';
import 'package:Okuna/widgets/toast.dart';
import 'package:Okuna/translation/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter\_localizations/flutter\_localizations.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';

import 'delegates/es_es_localizations_delegate.dart';
import 'delegates/pt_br_localizations_delegate.dart';
import 'delegates/sv_se_localizations_delegate.dart';

class MyApp extends StatefulWidget {
  final openbookProviderKey = new GlobalKey<OpenbookProviderState>();

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.ancestorStateOfType(TypeMatcher<_MyAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = _defaultTextTheme();
    return OpenbookProvider(
      key: widget.openbookProviderKey,
      child: OBToast(
        child: MaterialApp(
            locale: this.locale,
            debugShowCheckedModeBanner: false,
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              // if no deviceLocale use english
              if (deviceLocale == null) {
                this.locale = Locale('en', 'US');
                return this.locale;
              }
              // initialise locale from device
              if (deviceLocale != null &&
                  supportedLanguages.contains(deviceLocale.languageCode) &&
                  this.locale == null) {
                Locale supportedMatchedLocale = supportedLocales.firstWhere(
                    (Locale locale) =>
                        locale.languageCode == deviceLocale.languageCode);
                this.locale = supportedMatchedLocale;
              } else if (this.locale == null) {
                print(
                    'Locale ${deviceLocale.languageCode} not supported, defaulting to en');
                this.locale = Locale('en', 'US');
              }
              return this.locale;
            },
            title: 'Okuna',
            supportedLocales: supportedLocales,
            localizationsDelegates: [
              const LocalizationServiceDelegate(),
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              const MaterialLocalizationPtBRDelegate(),
              const CupertinoLocalizationPtBRDelegate(),
              const MaterialLocalizationEsESDelegate(),
              const CupertinoLocalizationEsESDelegate(),
              const MaterialLocalizationSvSEDelegate(),
              const CupertinoLocalizationSvSEDelegate(),
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
                fontFamily: 'NunitoSans',
                textTheme: textTheme,
                primaryTextTheme: textTheme,
                accentTextTheme: textTheme),
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
              '/auth/token': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthCreateAccountPage();
              },
              '/auth/get-started': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthGetStartedPage();
              },
              '/auth/guidelines_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthGuidelinesStepPage();
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
              },
              '/auth/forgot_password_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthForgotPasswordPage();
              },
              '/auth/verify_reset_password_link_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthVerifyPasswordPage();
              },
              '/auth/set_new_password_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthSetNewPasswordPage();
              },
              '/auth/password_reset_success_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBAuthPasswordResetSuccessPage();
              },
              '/waitlist/subscribe_email_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                return OBWaitlistSubscribePage();
              },
              '/waitlist/subscribe_done_step': (BuildContext context) {
                bootstrapOpenbookProviderInContext(context);
                WaitlistSubscribeArguments args =
                    ModalRoute.of(context).settings.arguments;
                return OBWaitlistSubscribeDoneStep(count: args.count);
              }
            }),
      ),
    );
  }

  void bootstrapOpenbookProviderInContext(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = LocalizationService.of(context);
    if (this.locale.languageCode !=
        localizationService.getLocale().languageCode) {
      Future.delayed(Duration(milliseconds: 0), () {
        MyApp.setLocale(context, this.locale);
      });
    }
    openbookProvider.setLocalizationService(localizationService);
    UniversalLinksService universalLinksService =
        openbookProvider.universalLinksService;
    universalLinksService.digestLinksWithContext(context);
    openbookProvider.validationService
        .setLocalizationService(localizationService);
  }
}

void _setPlatformOverrideForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

Future<Null> main() async {
  _setPlatformOverrideForDesktop();
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isOnDesktop) {
      // Report errors on Desktop to embedder
      DesktopErrorReporting.reportError(details.exception, details.stack);
    } else if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // This creates a [Zone] that contains the Flutter application and stablishes
  // an error handler that captures errors and reports them.
  //
  // Using a zone makes sure that as many errors as possible are captured,
  // including those thrown from [Timer]s, microtasks, I/O, and those forwarded
  // from the `FlutterError` handler.
  //
  // More about zones:
  //
  // - https://api.dartlang.org/stable/1.24.2/dart-async/Zone-class.html
  // - https://www.dartlang.org/articles/libraries/zones

  MyApp app;
  runZoned<Future<Null>>(() async {
    app = MyApp();
    runApp(app);
  }, onError: (error, stackTrace) async {
    if (isOnDesktop) {
      DesktopErrorReporting.reportError(error, stackTrace);
      return;
    }
    SentryClient sentryClient =
        app.openbookProviderKey.currentState.sentryClient;
    await _reportError(error, stackTrace, sentryClient);
  });
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(
    dynamic error, dynamic stackTrace, SentryClient sentryClient) async {
  print('Caught error: $error');

  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');
  final SentryResponse response = await sentryClient.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

bool get isOnDesktop {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

TextTheme _defaultTextTheme() {
  // This text theme is merged with the default theme in the `TextData`
  // constructor. This makes sure that the emoji font is used as fallback for
  // every text that uses the default theme.
  var style;
  if (isOnDesktop) {
    style = new TextStyle(fontFamilyFallback: ['Emoji']);
  }
  return new TextTheme(
    body1: style,
    body2: style,
    button: style,
    caption: style,
    display1: style,
    display2: style,
    display3: style,
    display4: style,
    headline: style,
    overline: style,
    subhead: style,
    subtitle: style,
    title: style,
  );
}
