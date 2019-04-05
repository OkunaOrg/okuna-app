#import "ShareViewController.h"

const NSString* APP_GROUP_NAME = @"group.social.openbook.app";

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
  // Do validation of contentText and/or NSExtensionContext attachments here
  return YES;
}

- (NSString*)getTempDir {
  NSFileManager* manager = [NSFileManager defaultManager];
  NSString* tempDir = [[[manager containerURLForSecurityApplicationGroupIdentifier:APP_GROUP_NAME] path] stringByAppendingPathComponent:@"tmp"];

  BOOL isDir;
  NSError* error = nil;

  if (![manager fileExistsAtPath:tempDir isDirectory:&isDir]) {
    if (![manager createDirectoryAtPath:tempDir withIntermediateDirectories:YES attributes:nil error:&error]) {
      // TODO: handle error
    }
  }

  return tempDir;
}

- (NSString*) getTempFileWithExtension:(NSString*)extension {
  NSString* fileName = [[NSUUID UUID] UUIDString];
  NSString* tempFile = [fileName stringByAppendingPathExtension:extension];

  return tempFile;
}

- (void)callOpenbookAppWithSharedFileName:(NSString*)fileName {
  NSURL* url = [[NSURL URLWithString:@"openbook://share"] URLByAppendingPathComponent:fileName];
  SEL selectorOpenURL = sel_registerName("openURL:");
  NSExtensionContext* context = self.extensionContext;
  [context openURL:url completionHandler:nil];

  UIResponder* responder = (UIResponder*)self;
  while (responder != nil) {
    if ([responder respondsToSelector:selectorOpenURL]) {
      [responder performSelector:selectorOpenURL withObject:url];
    }
    responder = responder.nextResponder;
  }
}

- (void)didSelectPost {
  // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
  NSFileManager* manager = [NSFileManager defaultManager];
  NSExtensionContext* context = self.extensionContext;
  NSArray* images = context.inputItems;
  NSString* tempPath = [self getTempDir];
  NSString* fileName = [self getTempFileWithExtension:@"jpg"];
  // TODO: write image to file

  // As we have to communicate text and an image to the app, write everything to a file instead of putting everything in an URL.
  NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
  args[@"text"] = self.contentText;
  args[@"path"] = [tempPath stringByAppendingPathComponent:fileName];
  NSError* error;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
  // TODO: handle error
  NSString* jsonFile = [self getTempFileWithExtension:@"json"];
  if (![manager createFileAtPath:[tempPath stringByAppendingPathComponent:jsonFile] contents:jsonData attributes:nil]) {
    // TODO: handle error
  }
  // call main app
  [self callOpenbookAppWithSharedFileName:jsonFile];
  // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
  // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
  return @[];
}

@end
