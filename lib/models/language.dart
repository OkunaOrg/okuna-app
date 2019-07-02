class Language {
  final String code;
  final String name;
  final int id;

  Language(
      {this.code,
       this.name,
       this.id,
       });

  factory Language.fromJson(Map<String, dynamic> parsedJson) {

    return Language(
        id: parsedJson['id'],
        code: parsedJson['code'],
        name: parsedJson['name'],
       );
  }
}
