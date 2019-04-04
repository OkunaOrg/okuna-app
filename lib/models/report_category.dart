class ReportCategory {
  final int id;
  final String name;
  final String title;
  final String description;

  ReportCategory(
      { this.id,
        this.name,
        this.title,
        this.description
      });

  factory ReportCategory.fromJson(Map<String, dynamic> parsedJson) {
    String parsedTitle;
    String parsedDescription;

    if (parsedJson.containsKey('title')) {
      parsedTitle = parsedJson['title'];
    }

    if (parsedJson.containsKey('description')) {
      parsedDescription = parsedJson['description'];
    }

    return ReportCategory(
        id: parsedJson['id'],
        name: parsedJson['name'],
        title: parsedTitle,
        description: parsedDescription
    );
  }
}
