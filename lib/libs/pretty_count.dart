String getPrettyCount(int value) {
  String postfix;
  double finalValue = value.toDouble();

  if (value < 0) {
    throw 'Invalid value';
  } else if (value < 1000) {
    return value.toString();
  } else if (value < 1000000) {
    postfix = 'k';
    finalValue = value / 1000;
  } else if (value < 1000000000) {
    postfix = 'm';
    finalValue = value / 1000000;
  } else if (value < 1000000000000) {
    postfix = 'b';
    finalValue = value / 1000000000;
  }

  return finalValue.toString() + postfix;
}
