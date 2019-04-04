import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pigment/pigment.dart';
import "dart:math" show pi;

class OBZoomablePhotoModal extends StatefulWidget {
  final String imageUrl;

  OBZoomablePhotoModal(this.imageUrl);

  @override
  State<StatefulWidget> createState() {
    return OBZoomablePhotoModalState();
  }
}

class OBZoomablePhotoModalState extends State<OBZoomablePhotoModal>
    with SingleTickerProviderStateMixin {
  bool isDismissible;
  AnimationController controller;
  Animation<Offset> offset;
  Animation<double> rotation;
  double _rotationAngle;
  double _rotationDirection;
  double _posX;
  double _posY;
  double _velocityX;
  double _velocityY;
  PointerDownEvent startDragDetails;
  PointerMoveEvent updateDragDetails;
  static const VELOCITY_THRESHOLD = 10.0;
  static const CLOCKWISE = 1.0;
  static const ANTICLOCKWISE = -1.0;


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _rotationAngle = 0.0;
    _rotationDirection = CLOCKWISE;
    _posX = 0.0;
    _velocityX = 0.0;
    _velocityY = 0.0;
    _posY = 0.0;
    isDismissible = true;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      child: OBCupertinoPageScaffold(
          backgroundColor: Colors.black,
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Listener(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    _getPositionedZoomableImage()
                  ],
                ),
                onPointerDown: (PointerDownEvent details) {
                  if (startDragDetails == null) {
                    setState(() {
                      startDragDetails = details;
                    });
                  }
                },
                onPointerMove: (PointerMoveEvent updatedDetails) {
                  double deltaY = 0.0;
                  double deltaX = 0.0;
                  if (updateDragDetails == null && startDragDetails != null) {
                    deltaY = updatedDetails.position.dy - startDragDetails.position.dy;
                    deltaX = updatedDetails.position.dx - startDragDetails.position.dx;
                  } else if (updateDragDetails != null) {
                    deltaY = updatedDetails.position.dy - updateDragDetails.position.dy;
                    deltaX = updatedDetails.position.dx - updateDragDetails.position.dx;
                  }
                  _updateDragValues(deltaX, deltaY, updatedDetails);

                },
                onPointerUp: (PointerUpEvent details) {
                  _checkIsDismissible();
                },
              ),
              _buildCloseButton()
            ],
          )),
      onWillPop: _dismissModalNoPop,
    );
  }

  Widget _getPositionedZoomableImage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: _posY != 0 ? _posY: 0,
      left: _posX != 0 ? _posX: 0,
      width: screenWidth,
      height: screenHeight,
      child: Transform.rotate(
        angle: _rotationAngle,
        child: PhotoView(
          backgroundDecoration:
          BoxDecoration(color: Colors.black),
          key: Key(widget.imageUrl),
          enableRotation: false,
          scaleStateChangedCallback:
          _photoViewScaleStateChangedCallback,
          imageProvider: AdvancedNetworkImage(widget.imageUrl,
              retryLimit: 0,
              useDiskCache: true,
              fallbackAssetImage:
              'assets/images/fallbacks/post-fallback.png'),
          maxScale: PhotoViewComputedScale.covered,
          minScale: PhotoViewComputedScale.contained,
        ),
      ),
    );


  }

  void _updateDragValues(double deltaX, double deltaY, PointerMoveEvent updatedDetails) {
    if (deltaX.abs() > 50.0 || deltaY.abs() > 50.0 || !isDismissible) return;
    setState(() {
      _posX = _posX + deltaX;
      _posY = _posY + deltaY;
      updateDragDetails = updatedDetails;
    });
    _updateRotationValues();
    // Last reading of velocity is low (below threshold) as the finger leaves the screen,
    // which causes the dismiss to be cancelled, so we update it lazily.
    _updateVelocityLazily(deltaX, deltaY);

  }

  void _updateVelocityLazily(double deltaX, double deltaY) async {
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        _velocityX = deltaX;
        _velocityY = deltaY;
      });
    });
  }

  void _setBackToOrginalPosition() {
    setState(() {
      offset = Tween<Offset>(begin: Offset(_posX, _posY), end: Offset(0.0, 0.0))
          .chain(CurveTween(curve: Curves.easeInOutSine))
          .animate(controller)..addListener(() {
        _posX = offset.value.dx;
        _posY = offset.value.dy;
        setState(() {});
      });
      startDragDetails = null;
      updateDragDetails = null;
    });
    rotation = Tween<double>(begin: _rotationAngle, end: 0.0)
        .chain(CurveTween(curve: Curves.easeInOutCubic))
        .animate(controller)
      ..addListener(() {
        _rotationAngle = rotation.value;
        setState(() {});
      });
    controller.reset();
    controller.forward();
  }

  void _checkIsDismissible() {
    if (_velocityX.abs() > VELOCITY_THRESHOLD || _velocityY.abs() > VELOCITY_THRESHOLD) {
      _setTweensWithVelocity();
      _dismissModal();
    } else {
      _setBackToOrginalPosition();
    }
  }

  void _updateRotationValues() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenMid = screenWidth/2;
    double maxRotationAngle = pi/2;
    // Rotation increases proportional to distance from mid of screen
    double rotationRatio = (startDragDetails.position.dx - screenMid).abs() / screenMid;

    if (startDragDetails.position.dx < screenMid) {
      maxRotationAngle = -pi/2;
    }
    // Rotation increases proportional to drag in Y direction
    double distanceRatio = _posY/screenHeight;

    double rotationDirection;
    if ((maxRotationAngle < 0 && _velocityY < 0) || (maxRotationAngle > 0 && _velocityY > 0)) {
      rotationDirection = CLOCKWISE;
    } else {
      rotationDirection = ANTICLOCKWISE;
    }
    setState(() {
      _rotationAngle = distanceRatio * rotationRatio * maxRotationAngle;
      _rotationDirection = rotationDirection;
    });
  }

  void _setTweensWithVelocity() {
    setState(() {
      offset = Tween<Offset>(begin: Offset(_posX, _posY), end: Offset(_velocityX * 50.0, _velocityY * 50.0))
          .chain(CurveTween(curve: Curves.easeInOutSine))
          .animate(controller)..addListener(() {
        _posX = offset.value.dx + _velocityX/2;
        _posY = offset.value.dy + _velocityY/2;
        setState(() {});
      });

      rotation = Tween<double>(begin: _rotationAngle, end: 2 * pi * _rotationDirection)
          .chain(CurveTween(curve: Curves.easeInOutCubic))
          .animate(controller)
        ..addListener(() {
          _rotationAngle = rotation.value;
          setState(() {});
        });

      startDragDetails = null;
      updateDragDetails = null;
    });
    controller.reset();
  }

  Future _dismissModal() async {
    await controller.forward();
    Navigator.pop(context);
  }

  Future<bool> _dismissModalNoPop() async {
    _dismissModal();
    return false;
  }

  Widget _buildCloseButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: SafeArea(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTapDown: (tap) {
                  _dismissModal();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Pigment.fromString('#1d1d1d'),
                      borderRadius: BorderRadius.circular(50)),
                  child: const OBIcon(
                    OBIcons.close,
                    size: OBIconSize.large,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _photoViewScaleStateChangedCallback(PhotoViewScaleState state) {
    switch (state) {
      case PhotoViewScaleState.initial:
        _setIsDismissible(true);
        break;
      default:
        _setIsDismissible(false);
    }
  }

  void _setIsDismissible(bool isDismissible) {
    setState(() {
      this.isDismissible = isDismissible;
    });
  }

  void toggleIsDismissible() {
    _setIsDismissible(!isDismissible);
  }
}
