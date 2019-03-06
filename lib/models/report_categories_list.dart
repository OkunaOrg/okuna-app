
import 'package:Openbook/models/report_category.dart';

class ReportCategoriesList {
  final List<ReportCategory> categories;

  ReportCategoriesList({
    this.categories,
  });

  factory ReportCategoriesList.fromJson(List<dynamic> parsedJson) {
    List<ReportCategory> categories = parsedJson
        .map((categoryJson) => ReportCategory.fromJson(categoryJson))
        .toList();

    return new ReportCategoriesList(
      categories: categories,
    );
  }
}
