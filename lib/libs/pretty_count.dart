import 'package:Openbook/services/localization.dart';

String getPrettyCount(int value, LocalizationService localizationService) {
  String postfix;
  double finalValue;

  if (value < 0) {
    throw 'Invalid value';
  } else if (value < 1000) {
    return value.toString();
  } else if (value < 1000000) {
    postfix = localizationService.user__thousand_postfix;
    finalValue = value / 1000;
  } else if (value < 1000000000) {
    postfix = localizationService.user__million_postfix;
    finalValue = value / 1000000;
  } else if (value < 1000000000000) {
    postfix = localizationService.user__billion_postfix;
    finalValue = value / 1000000000;
  }

  return finalValue.round().toString() + postfix;
}
