import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBLoadingIndicatorTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Center(
        child: OBProgressIndicator(),
      ),
    );
  }
}
