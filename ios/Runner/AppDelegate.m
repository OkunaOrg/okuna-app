#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "ImageConverterPlugin.h"
#import <uni_links/UniLinksPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [ImageConverterPlugin registerWithRegistrar:[self registrarForPlugin:@"ImageConverterPlugin"]];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    return [[UniLinksPlugin sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end
