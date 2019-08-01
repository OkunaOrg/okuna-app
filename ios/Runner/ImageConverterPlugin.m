//
// Created by Openbook on 2019-07-31.
// Copyright (c) 2019 Openbook B.V. All rights reserved.
//

#import "ImageConverterPlugin.h"

typedef NS_ENUM(NSInteger, TargetFormat) {
    TargetFormatJPEG,
    TargetFormatPNG
};

@implementation ImageConverterPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
            [FlutterMethodChannel methodChannelWithName:@"openspace.social/image_converter"
                                        binaryMessenger:[registrar messenger]];
    ImageConverterPlugin *instance = [[ImageConverterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"convertImage"]) {
        [self convertImageFromMethodCall:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)convertImageFromMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSData *imageData = [call.arguments[@"imageData"] data];
    NSString *formatString = call.arguments[@"format"];
    TargetFormat format;
    if ([formatString isEqualToString:@"JPEG"]) {
        format = TargetFormatJPEG;
    } else if ([formatString isEqualToString:@"PNG"]) {
        format = TargetFormatPNG;
    } else {
        result([FlutterError
                errorWithCode:@"unkown_format"
                      message:@"Unknown image format"
                      details:formatString]);
        return;
    }
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) {
        result([FlutterError
                errorWithCode:@"bad_data"
                      message:@"Failed to open image"
                      details:nil]);
        return;
    }
    switch (format) {
        case TargetFormatJPEG:
            imageData = UIImageJPEGRepresentation(image, 1.0);
            break;
        case TargetFormatPNG:
            imageData = UIImagePNGRepresentation(image);
            break;
        default:
            result([FlutterError
                    errorWithCode:@"unknown_format"
                          message:@"Unknown image format"
                          details:formatString]);
            return;
    }
    result(imageData);
}
@end
