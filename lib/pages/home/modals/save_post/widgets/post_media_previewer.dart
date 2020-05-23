import 'dart:io';

import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_video.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_image_previewer.dart';
import 'package:Okuna/pages/home/modals/save_post/widgets/post_video_previewer.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBPostMediaPreview extends StatefulWidget {
  final VoidCallback onRemove;

  OBPostMediaPreview({Key key, this.onRemove})
      : super(key: key);

  @override
  _OBPostMediaPreviewState createState() =>
      _OBPostMediaPreviewState();
}

class _OBPostMediaPreviewState extends State<OBPostMediaPreview> {
  final double buttonSize = 30.0;

  _OBPostMediaPreviewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgressIndicator();
  }

  Widget _buildProgressIndicator() {
    var provider = OpenbookProvider.of(context);
    ThemeValueParserService themeParserService =
        provider.themeValueParserService;
    OBTheme theme = provider.themeService.getActiveTheme();

    double avatarBorderRadius = 10.0;

    var background = SizedBox(
      height: 200.0,
      width: 200,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(avatarBorderRadius),
        child: Container(
          color: Colors.grey,
          child: Center(
            child: OBProgressIndicator(
              size: 40,
              color: themeParserService
                  .parseGradient(theme.primaryTextColor)
                  .colors
                  .first,
            ),
          ),
        ),
      ),
    );

    if (widget.onRemove == null) return background;

    return Stack(
      children: <Widget>[
        background,
        Positioned(
          top: 10,
          right: 10,
          child: _buildRemoveButton(),
        ),
      ],
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: widget.onRemove,
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FloatingActionButton(
          heroTag: Key('postMediaPreviewerRemoveButton'),
          onPressed: widget.onRemove,
          backgroundColor: Colors.black54,
          child: Icon(
            Icons.clear,
            color: Colors.white,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
