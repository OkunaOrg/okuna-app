#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "ReceiveShareStreamHandler.h"
#import <uni_links/UniLinksPlugin.h>
#import <Flutter/Flutter.h>

@implementation AppDelegate {
  ReceiveShareStreamHandler* _receiveShareStreamHandler;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  _receiveShareStreamHandler = [ReceiveShareStreamHandler receiveShareStreamHandlerWithController: controller];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    return [[UniLinksPlugin sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

  if ([url.scheme isEqualToString:@"openbook"]) {
    NSLog(@"Handling openURL: %@", [url absoluteString]);
  }
  return [super application:app openURL:url options:options];
}

@end
