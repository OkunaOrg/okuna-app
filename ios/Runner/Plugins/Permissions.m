#import "Permissions.h"

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@implementation Permissions

+ (void) registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*) registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"openbook.social/permissions" binaryMessenger:[registrar messenger]];
  Permissions* instance = [[Permissions alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* method = [call method];
  if ([method isEqualToString:@"checkPermission"]) {
    [self checkPermission:call.arguments[@"permission"] result:result];
  } else if ([method isEqualToString:@"requestPermission"]) {
    [self requestPermission:call.arguments[@"permission"] result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)checkPermission:(NSString*)permission result:(FlutterResult)result {
  if ([permission isEqualToString:@"WRITE_EXTERNAL_STORAGE"]) {
    // storage permission doesn't exist on iOS
    result([NSNumber numberWithBool:YES]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)requestPermission:(NSString*)permission result:(FlutterResult)result {
  if ([permission isEqualToString:@"WRITE_EXTERNAL_STORAGE"]) {
    // storage permission doesn't exist on iOS
    result([NSNumber numberWithBool:YES]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
