// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:Openbook/locale/messages_all.dart';

import '../main.dart';

class LocalizationService {
  LocalizationService(this.locale);

  final Locale locale;

  Future<LocalizationService> load() {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new LocalizationService(locale);
    });
  }

  static LocalizationService of(BuildContext context) {
    StreamSubscription _onLoggedInUserChangeSubscription;
    var openbookProvider = OpenbookProvider.of(context);
    _onLoggedInUserChangeSubscription =
        openbookProvider.userService.loggedInUserChange.listen((User newUser) {
      String _userLanguageCode = openbookProvider.userService.getLoggedInUser().language.code;
      Locale _currentLocale = Localizations.localeOf(context);
      if (_userLanguageCode != _currentLocale.languageCode) {
        print('Overriding locale ${_currentLocale.languageCode} with user locale: $_userLanguageCode');
        MyApp.setLocale(context, Locale(_userLanguageCode, ''));
      }
       _onLoggedInUserChangeSubscription.cancel();
    });

    return Localizations.of<LocalizationService>(context, LocalizationService);
  }

  String trans(String key) {
    return Intl.message(key, name: key);
  }

  String get auth__headline {
    return Intl.message("Better social.", name: 'auth__headline');
  }
  String get auth__login {
    return Intl.message("Log in", name: 'auth__login');
  }
  String get auth__create_account {
    return Intl.message("Sign up", name: 'auth__create_account');
  }
  String get auth__create_acc__lets_get_started {
    return Intl.message("Let's get started", name: 'auth__create_acc__lets_get_started');
  }
  String get auth__create_acc__welcome_to_alpha {
    return Intl.message("Welcome to the Alpha!", name: 'auth__create_acc__welcome_to_alpha');
  }
  String get auth__create_acc__previous {
    return Intl.message("Back", name: 'auth__create_acc__previous');
  }
  String get auth__create_acc__next {
    return Intl.message("Next", name: 'auth__create_acc__next');
  }
  String get auth__create_acc__create_account {
    return Intl.message("Create account", name: 'auth__create_acc__create_account');
  }
  String get auth__create_acc__paste_link {
    return Intl.message("Paste your registration link below", name: 'auth__create_acc__paste_link');
  }
  String get auth__create_acc__paste_password_reset_link {
    return Intl.message("Paste your password reset link below", name: 'auth__create_acc__paste_password_reset_link');
  }
  String get auth__create_acc__paste_link_help_text {
    return Intl.message("Use the link from the Join Openbook button in your invitation email.", name: 'auth__create_acc__paste_link_help_text');
  }
  String get auth__create_acc__request_invite {
    return Intl.message("No invite? Request one here.", name: 'auth__create_acc__request_invite');
  }
  String get auth__create_acc__subscribe {
    return Intl.message("Request", name: 'auth__create_acc__subscribe');
  }
  String get auth__create_acc__subscribe_to_waitlist_text {
    return Intl.message("Request an invite!", name: 'auth__create_acc__subscribe_to_waitlist_text');
  }
  String get auth__create_acc__congratulations {
    return Intl.message("Congratulations!", name: 'auth__create_acc__congratulations');
  }
  String get auth__create_acc__your_subscribed {
    return Intl.message("You're {0} on the waitlist.", name: 'auth__create_acc__your_subscribed');
  }
  String get auth__create_acc__almost_there {
    return Intl.message("Almost there...", name: 'auth__create_acc__almost_there');
  }
  String get auth__create_acc__what_name {
    return Intl.message("What's your name?", name: 'auth__create_acc__what_name');
  }
  String get auth__create_acc__name_placeholder {
    return Intl.message("James Bond", name: 'auth__create_acc__name_placeholder');
  }
  String get auth__create_acc__name_empty_error {
    return Intl.message("😱 Your name can't be empty.", name: 'auth__create_acc__name_empty_error');
  }
  String get auth__create_acc__name_length_error {
    return Intl.message("😱 Your name can't be longer than 50 characters. (If it is, we're very sorry.)", name: 'auth__create_acc__name_length_error');
  }
  String get auth__create_acc__name_characters_error {
    return Intl.message("😅 A name can only contain alphanumeric characters (for now).", name: 'auth__create_acc__name_characters_error');
  }
  String get auth__create_acc__what_username {
    return Intl.message("Choose a username", name: 'auth__create_acc__what_username');
  }
  String get auth__create_acc__username_placeholder {
    return Intl.message("pablopicasso", name: 'auth__create_acc__username_placeholder');
  }
  String get auth__create_acc__username_empty_error {
    return Intl.message("😱 The username can't be empty.", name: 'auth__create_acc__username_empty_error');
  }
  String get auth__create_acc__username_length_error {
    return Intl.message("😅 A username can't be longer than 30 characters.", name: 'auth__create_acc__username_length_error');
  }
  String get auth__create_acc__username_characters_error {
    return Intl.message("😅 A username can only contain alphanumeric characters and underscores.", name: 'auth__create_acc__username_characters_error');
  }
  String get auth__create_acc__username_taken_error {
    return Intl.message("😩 The username @%s is taken.", name: 'auth__create_acc__username_taken_error');
  }
  String get auth__create_acc__username_server_error {
    return Intl.message("😭 We're experiencing issues with our servers, please try again in a couple of minutes.", name: 'auth__create_acc__username_server_error');
  }
  String get auth__create_acc__what_email {
    return Intl.message("What's your email?", name: 'auth__create_acc__what_email');
  }
  String get auth__create_acc__email_placeholder {
    return Intl.message("john_travolta@mail.com", name: 'auth__create_acc__email_placeholder');
  }
  String get auth__create_acc__email_empty_error {
    return Intl.message("😱 Your email can't be empty", name: 'auth__create_acc__email_empty_error');
  }
  String get auth__create_acc__email_invalid_error {
    return Intl.message("😅 Please provide a valid email address.", name: 'auth__create_acc__email_invalid_error');
  }
  String get auth__create_acc__email_taken_error {
    return Intl.message("🤔 An account already exists for that email.", name: 'auth__create_acc__email_taken_error');
  }
  String get auth__create_acc__email_server_error {
    return Intl.message("😭 We're experiencing issues with our servers, please try again in a couple of minutes.", name: 'auth__create_acc__email_server_error');
  }
  String get auth__create_acc__what_password {
    return Intl.message("Choose a password", name: 'auth__create_acc__what_password');
  }
  String get auth__create_acc__what_password_subtext {
    return Intl.message("(min 10 chars.)", name: 'auth__create_acc__what_password_subtext');
  }
  String get auth__create_acc__password_empty_error {
    return Intl.message("😱 Your password can't be empty", name: 'auth__create_acc__password_empty_error');
  }
  String get auth__create_acc__password_length_error {
    return Intl.message("😅 A password must be between 8 and 64 characters.", name: 'auth__create_acc__password_length_error');
  }
  String get auth__create_acc__what_avatar {
    return Intl.message("Choose a profile picture", name: 'auth__create_acc__what_avatar');
  }
  String get auth__create_acc__avatar_tap_to_change {
    return Intl.message("Tap to change", name: 'auth__create_acc__avatar_tap_to_change');
  }
  String get auth__create_acc__avatar_choose_camera {
    return Intl.message("Take a photo", name: 'auth__create_acc__avatar_choose_camera');
  }
  String get auth__create_acc__avatar_choose_gallery {
    return Intl.message("Use an existing photo", name: 'auth__create_acc__avatar_choose_gallery');
  }
  String get auth__create_acc__avatar_remove_photo {
    return Intl.message("Remove photo", name: 'auth__create_acc__avatar_remove_photo');
  }
  String get auth__create_acc__done {
    return Intl.message("Create account", name: 'auth__create_acc__done');
  }
  String get auth__create_acc__enter {
    return Intl.message("Enter", name: 'auth__create_acc__enter');
  }
  String get auth__create_acc__submit_loading_title {
    return Intl.message("Hang in there!", name: 'auth__create_acc__submit_loading_title');
  }
  String get auth__create_acc__submit_loading_desc {
    return Intl.message("We're creating your account.", name: 'auth__create_acc__submit_loading_desc');
  }
  String get auth__create_acc__submit_error_title {
    return Intl.message("Oh no...", name: 'auth__create_acc__submit_error_title');
  }
  String get auth__create_acc__submit_error_desc_server {
    return Intl.message("😭 We're experiencing issues with our servers, please try again in a couple of minutes.", name: 'auth__create_acc__submit_error_desc_server');
  }
  String get auth__create_acc__submit_error_desc_validation {
    return Intl.message("😅 It looks like some of the information was not right, please check and try again.", name: 'auth__create_acc__submit_error_desc_validation');
  }
  String get auth__create_acc__done_title {
    return Intl.message("Hooray!", name: 'auth__create_acc__done_title');
  }
  String get auth__create_acc__done_description {
    return Intl.message("Your account has been created.", name: 'auth__create_acc__done_description');
  }
  String get auth__create_acc__your_username_is {
    return Intl.message("Your user name is ", name: 'auth__create_acc__your_username_is');
  }
  String get auth__create_acc__can_change_username {
    return Intl.message("If you wish, you can change it anytime via your profile page.", name: 'auth__create_acc__can_change_username');
  }
  String get auth__create_acc__done_continue {
    return Intl.message("Login", name: 'auth__create_acc__done_continue');
  }
  String get auth__login__login {
    return Intl.message("Continue", name: 'auth__login__login');
  }
  String get auth__login__previous {
    return Intl.message("Previous", name: 'auth__login__previous');
  }
  String get auth__login__title {
    return Intl.message("Welcome back!", name: 'auth__login__title');
  }
  String get auth__login__subtitle {
    return Intl.message("Enter your credentials to continue.", name: 'auth__login__subtitle');
  }
  String get auth__login__forgot_password {
    return Intl.message("Forgot password", name: 'auth__login__forgot_password');
  }
  String get auth__login__forgot_password_subtitle {
    return Intl.message("Enter your username or email", name: 'auth__login__forgot_password_subtitle');
  }
  String get auth__login__username_label {
    return Intl.message("Username", name: 'auth__login__username_label');
  }
  String get auth__login__password_label {
    return Intl.message("Password", name: 'auth__login__password_label');
  }
  String get auth__login__email_label {
    return Intl.message("Email", name: 'auth__login__email_label');
  }
  String get auth__login__or_text {
    return Intl.message("Or", name: 'auth__login__or_text');
  }
  String get auth__login__password_empty_error {
    return Intl.message("Password is required.", name: 'auth__login__password_empty_error');
  }
  String get auth__login__password_length_error {
    return Intl.message("Password must be between 8 and 64 characters.", name: 'auth__login__password_length_error');
  }
  String get auth__login__username_empty_error {
    return Intl.message("Username is required.", name: 'auth__login__username_empty_error');
  }
  String get auth__login__username_length_error {
    return Intl.message("Username can't be longer than 30 characters.", name: 'auth__login__username_length_error');
  }
  String get auth__login__username_characters_error {
    return Intl.message("Username can only contain alphanumeric characters and underscores.", name: 'auth__login__username_characters_error');
  }
  String get auth__login__credentials_mismatch_error {
    return Intl.message("The provided credentials do not match.", name: 'auth__login__credentials_mismatch_error');
  }
  String get auth__login__server_error {
    return Intl.message("Uh oh.. We're experiencing server issues. Please try again in a few minutes.", name: 'auth__login__server_error');
  }
  String get auth__login__connection_error {
    return Intl.message("We can't reach our servers. Are you connected to the internet?", name: 'auth__login__connection_error');
  }

  String get drawer__profile {
    return Intl.message("Profile", name: 'drawer__profile');
  }
  String get drawer__connections {
    return Intl.message("My connections", name: 'drawer__connections');
  }
  String get drawer__lists {
    return Intl.message("My lists", name: 'drawer__lists');
  }
  String get drawer__settings {
    return Intl.message("Account Settings", name: 'drawer__settings');
  }
  String get drawer__help {
    return Intl.message("Support & Feedback", name: 'drawer__help');
  }
  String get drawer__customize {
    return Intl.message("Customize", name: 'drawer__customize');
  }
  String get drawer__logout {
    return Intl.message("Log out", name: 'drawer__logout');
  }

  String get settings__change_email {
    return Intl.message("Change Email", name: 'settings__change_email');
  }
  String get settings__change_password {
    return Intl.message("Change Password", name: 'settings__change_password');
  }

  Locale getLocale() {
    return locale;
  }
}
