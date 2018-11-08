import 'dart:ui';

class HexColor extends Color {
  HexColor(String value) : super(hexToInt(value));
}

int hexToInt(String hex) {
  return int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000;
}
