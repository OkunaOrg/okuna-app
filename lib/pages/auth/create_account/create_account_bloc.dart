import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class CreateAccountBloc {
  final _userRegistrationData = UserRegistrationData();

  Sink<DateTime> get birthday => _birthdayController.sink;
  final _birthdayController = StreamController<DateTime>();

  Sink<String> get email => _emailController.sink;
  final _emailController = StreamController<String>();

  Sink<String> get password => _passwordController.sink;
  final _passwordController = StreamController<String>();

  Sink<String> get username => _usernameController.sink;
  final _usernameController = StreamController<String>();

  Stream<String> get validatedEmail => _validatedEmailSubject.stream;

  final _validatedEmailSubject = BehaviorSubject<String>();

  Stream<String> get birthdayText => _birthdayTextSubject.stream;

  final _birthdayTextSubject = BehaviorSubject<String>();

  CreateAccountBloc() {
    _emailController.stream.listen(_onEmail);
    _passwordController.stream.listen(_onPassword);
    _usernameController.stream.listen(_onUsername);
    _birthdayController.stream.listen(_onBirthday);
  }

  void _onEmail(String email) {
    _userRegistrationData.email = email;
  }

  void _onUsername(String username) {
    _userRegistrationData.username = username;
  }

  void _onPassword(String password) {
    _userRegistrationData.password = password;
  }

  void _onBirthday(DateTime birthday) {
    String parsedDate = new DateFormat.yMd().format(birthday);
    _userRegistrationData.birthday = parsedDate;
    _birthdayTextSubject.add(parsedDate);
  }
}



class UserRegistrationData {
  String birthday;
  String username;
  String email;
  String password;
}
