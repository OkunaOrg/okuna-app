class StringTemplateService {
  String parse(String string, Map<String, dynamic> values) {
    String finalString = string;

    values.forEach((String key, dynamic value) {
      finalString = finalString.replaceAll('{$key}', value.toString());
    });

    return finalString;
  }
}
