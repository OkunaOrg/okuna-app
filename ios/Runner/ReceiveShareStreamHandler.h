#import <Flutter/Flutter.h>

@interface ReceiveShareStreamHandler : NSObject<FlutterStreamHandler>
+ (id)receiveShareStreamHandlerWithController:(FlutterViewController*)controller;
- (void)sendShareFromFile:(NSString*)fileName;
@end
