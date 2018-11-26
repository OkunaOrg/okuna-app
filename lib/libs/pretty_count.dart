String getPrettyCount(int value) {
  String postfix;

  if (value < 0) {
    throw 'Invalid value';
  } else if (value < 1000) {
    postfix = '';
  } else if (value < 1000000) {
    postfix = 'k';
  } else if (value < 1000000000) {
    postfix = 'm';
  } else {
    postfix = 'b';
  }

  return value.toString() + postfix;
}
