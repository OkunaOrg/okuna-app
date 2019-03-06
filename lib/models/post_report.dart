import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/report_category.dart';
import 'package:Openbook/models/user.dart';

class PostReport {
  final Post post;
  final User reporter;
  final String comment;
  final String status;
  final ReportCategory category;
  final DateTime created;

  PostReport(
      { this.post,
        this.reporter,
        this.comment,
        this.status,
        this.category,
        this.created
      });

  factory PostReport.fromJson(Map<String, dynamic> parsedJson) {
    Post post;
    User reporter;
    DateTime created;

    if (parsedJson['created'] != null) {
      created = DateTime.parse(parsedJson['created']).toLocal();
    }

    if (parsedJson.containsKey('post')) {
      post = Post.fromJson(parsedJson['post']);
    }

    if (parsedJson.containsKey('reporter')) {
      reporter = User.fromJson(parsedJson['reporter']);
    }

    return PostReport(
        post: post,
        reporter: reporter,
        status: parsedJson['status'],
        comment: parsedJson['comment'],
        category: ReportCategory.fromJson(parsedJson['category']),
        created: created
    );
  }
}
