#import <Flutter/Flutter.h>

@interface ReceiveShareStreamHandler : NSObject<FlutterStreamHandler>
+ (id)receiveShareStreamHandlerWithController:(FlutterViewController*)controller;
- (void)sendEventWithShare:(id)share;
@end
