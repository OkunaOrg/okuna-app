#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <uni_links/UniLinksPlugin.h>
#import "Plugins/Permissions.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [Permissions registerWithRegistrar:[self registrarForPlugin:@"Permission"]];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    return [[UniLinksPlugin sharedInstance] application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end
