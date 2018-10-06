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

  Sink<String> get name => _nameController.sink;
  final _nameController = StreamController<String>();

  Stream<String> get validatedEmail => _validatedEmailSubject.stream;

  final _validatedEmailSubject = BehaviorSubject<String>();

  Stream<String> get validatedName => _validatedNameSubject.stream;

  final _validatedNameSubject = BehaviorSubject<String>();

  Stream<String> get birthdayText => _birthdayTextSubject.stream;

  final _birthdayTextSubject = BehaviorSubject<String>();

  Stream<bool> get birthdayIsValid => _birthdayIsValidSubject.stream;

  final _birthdayIsValidSubject = BehaviorSubject<bool>();

  CreateAccountBloc() {
    _emailController.stream.listen(_onEmail);
    _nameController.stream.listen(_onName);
    _passwordController.stream.listen(_onPassword);
    _usernameController.stream.listen(_onUsername);
    _birthdayController.stream.listen(_onBirthday);
  }

  void _onEmail(String email) {
    _userRegistrationData.email = email;
  }

  void _onName(String name) {
    _userRegistrationData.name = name;
  }

  void _onUsername(String username) {
    _userRegistrationData.username = username;
  }

  void _onPassword(String password) {
    _userRegistrationData.password = password;
  }

  void _onBirthday(DateTime birthday) {
    if (birthday == null) {
      _birthdayIsValidSubject.add(false);
      return;
    }

    String parsedDate = new DateFormat.yMd().format(birthday);
    _userRegistrationData.birthday = parsedDate;
    _birthdayTextSubject.add(parsedDate);
    _birthdayIsValidSubject.add(true);
  }
}

class UserRegistrationData {
  String name;
  String birthday;
  String username;
  String email;
  String password;
}
