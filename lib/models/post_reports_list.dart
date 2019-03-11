import 'package:Openbook/models/post_report.dart';

class PostReportsList {
  final List<PostReport> reports;

  PostReportsList({
    this.reports,
  });

  factory PostReportsList.fromJson(List<dynamic> parsedJson) {
    List<PostReport> reports =
    parsedJson.map((postJson) => PostReport.fromJson(postJson)).toList();

    return new PostReportsList(
      reports: reports,
    );
  }
}
