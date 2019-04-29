#import "ReceiveShareStreamHandler.h"
#import <Foundation/Foundation.h>

const NSString* CHANNEL_NAME = @"openbook.social/receive_share";
const NSString* APP_GROUP_NAME = @"group.social.openbook.app";

@implementation ReceiveShareStreamHandler {
  FlutterEventChannel* _channel;
  FlutterEventSink _eventSink;
  BOOL _streamCanceled;
  NSMutableArray<NSString*>* _shareBacklog;
}

+ (id)receiveShareStreamHandlerWithController:(FlutterViewController *)controller {
  FlutterEventChannel* sharingChannel = [FlutterEventChannel
                                         eventChannelWithName: CHANNEL_NAME
                                         binaryMessenger: controller];
  return [[ReceiveShareStreamHandler alloc] initWithChannel:sharingChannel];
}

- (id)initWithChannel:(FlutterEventChannel*)channel {
  self = [super init];
  if (self) {
    _channel = channel;
    _shareBacklog = [NSMutableArray arrayWithCapacity:1];
    [_channel setStreamHandler:self];
  }
  return self;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  _eventSink = events;
  _streamCanceled = NO;
  while ([_shareBacklog count] > 0) {
    NSString* shareFile = _shareBacklog[0];
    [_shareBacklog removeObjectAtIndex:0];
    [self sendShareFromFile:shareFile];
  }
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  _streamCanceled = YES;
  return nil;
}

- (void)sendShareFromFile:(NSString*)fileName {
  if (_eventSink == nil) {
    if (!_streamCanceled && ![_shareBacklog containsObject:fileName]) {
      [_shareBacklog addObject:fileName];
    }
    return;
  }

  NSFileManager* manager = [NSFileManager defaultManager];
  NSString* tempDir = [[[manager containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME] path] stringByAppendingPathComponent:@"tmp"];
  NSString* fullFileName = [tempDir stringByAppendingPathComponent:fileName];
  NSError* error;
  NSDictionary* args = [NSJSONSerialization JSONObjectWithData:[manager contentsAtPath:fullFileName] options:0 error: &error];
  // TODO: handle error
  _eventSink(args);
}
@end
