class ValidationService {
  bool isQualifiedEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  /// TODO Implement
  bool isValidBirthday(DateTime birthday) {
    return true;
  }

  bool isAlphanumericWithSpaces(String str) {
    String p = r'^[a-z0-9\s]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(str);
  }

  bool isAlphanumericWithUnderscores(String str) {
    String p = r'^[a-zA-Z0-9_]+$';

    RegExp regExp = new RegExp(p, caseSensitive: false);

    return regExp.hasMatch(str);
  }

  bool isPasswordAllowedLength(String password) {
    return password.length >= 8 && password.length <= 64;
  }

  bool isUsernameAllowedLength(String username) {
    return username.length > 0 && username.length < 50;
  }

  bool isUsernameAllowedCharacters(String username) {
    return isAlphanumericWithUnderscores(username);
  }

  bool isNameAllowedLength(String name){
    return name.length >= 1 && name.length <= 50;
  }
}
