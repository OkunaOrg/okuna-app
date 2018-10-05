import 'dart:async';
import 'package:rxdart/rxdart.dart';

class CreateAccountBloc {
  final _userRegistrationData = UserRegistrationData();

  Sink<String> get email => _emailController.sink;
  final _emailController = StreamController<String>();

  Sink<String> get password => _passwordController.sink;
  final _passwordController = StreamController<String>();

  Sink<String> get username => _usernameController.sink;
  final _usernameController = StreamController<String>();

  Stream<String> get validatedEmail => _validatedEmailSubject.stream;

  final _validatedEmailSubject = BehaviorSubject<String>();

  CreateAccountBloc() {
    _emailController.stream.listen(_onEmail);
    _passwordController.stream.listen(_onPassword);
    _usernameController.stream.listen(_onUsername);
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
}

class UserRegistrationData {
  String username;
  String email;
  String password;
}
