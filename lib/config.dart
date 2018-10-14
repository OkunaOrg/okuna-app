enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class Config {
  static Flavor appFlavor;

  static String get apiURL {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'http://127.0.0.1:8000/';
      case Flavor.PRODUCTION:
        return 'https://api.openbook.social/';
      default:
        throw ('No Flavor configured');
    }
  }
}
