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
  // TODO: handle URL opening
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    return [[UniLinksPlugin sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end
