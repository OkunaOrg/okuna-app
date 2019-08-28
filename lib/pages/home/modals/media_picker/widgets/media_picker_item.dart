import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class OBMediaPickerItem extends StatefulWidget {
  final AssetEntity mediaAsset;
  final ValueChanged<AssetEntity> onPressed;

  const OBMediaPickerItem({Key key, @required this.mediaAsset, this.onPressed})
      : super(key: key);

  @override
  OBMediaPickerItemState createState() {
    return OBMediaPickerItemState();
  }
}

class OBMediaPickerItemState extends State<OBMediaPickerItem> {
  bool _needsBootstrap;
  Uint8List _thumbnailData;
  AssetType _type;
  Duration _duration;

  @override
  void initState() {
    super.initState();
    _type = widget.mediaAsset.type;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return _thumbnailData == null
        ? const SizedBox()
        : GestureDetector(
            onTap: _onPressed,
            child: _type == AssetType.image
                ? _buildImageThumbnail()
                : _buildVideoThumbnail());
  }

  Widget _buildImageThumbnail() {
    return Image.memory(
      _thumbnailData,
      fit: BoxFit.cover,
    );
  }

  Widget _buildVideoThumbnail() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(_thumbnailData),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(3)),
                child: Text(
                  _getStringifiedDuration(_duration),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }

  void _onPressed() {
    if (widget.onPressed != null) widget.onPressed(widget.mediaAsset);
  }

  void _bootstrap() async {
    List<dynamic> results = await Future.wait([
      widget.mediaAsset.thumbData,
      widget.mediaAsset.videoDuration,
    ]);

    Uint8List thumbnailBytes = results[0];
    Duration duration = results[1];

    setState(() {
      _thumbnailData = thumbnailBytes;
      _duration = duration;
    });
  }

  String _getStringifiedDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
