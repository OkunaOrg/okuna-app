import 'dart:math';

class ThemeService {
  static List OB_LOGO_COLORS = [
    '#48d9d9',
    '#5bc855',
    '#c1dc00',
    '#ffdd00',
    '#fbba00',
    '#f18700',
    '#ff6699',
    '#f93476'
  ];

  Random random = new Random();

  String getRandomObLogoHexColor() {
    return OB_LOGO_COLORS[random.nextInt(OB_LOGO_COLORS.length)];
  }
}
