import 'package:Okuna/libs/pretty_count.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/posts_count.dart';
import 'package:flutter/material.dart';

class OBProfilePostsCount extends StatelessWidget {
  final User user;

  OBProfilePostsCount(this.user);

  @override
  Widget build(BuildContext context) {
    return OBPostsCount(user.postsCount);
  }
}
