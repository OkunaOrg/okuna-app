#import "ReceiveShareStreamHandler.h"
#import <Foundation/Foundation.h>

const NSString* CHANNEL_NAME = @"openbook.social/receive_share";

@implementation ReceiveShareStreamHandler {
  FlutterEventChannel* _channel;
  FlutterEventSink _eventSink;
  BOOL _streamCanceled;
  NSMutableArray* _shareBacklog;
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
    id share = _shareBacklog[0];
    [_shareBacklog removeObjectAtIndex:0];
    [self sendEventWithShare:share];
  }
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  _streamCanceled = YES;
  return nil;
}

- (void)sendEventWithShare:(id)share {
  // TODO
}
@end
