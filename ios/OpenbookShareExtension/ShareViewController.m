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
  SEL selectorOpenURL = NSSelectorFromString(@"openURL:options:completionHandler:");

  UIResponder* responder = (UIResponder*)self;
  while ((responder = [responder nextResponder]) != nil) {
    if ([responder respondsToSelector:selectorOpenURL]) {
      NSMethodSignature* signature = [responder methodSignatureForSelector:selectorOpenURL];
      NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
      NSDictionary<NSString*,id>* options = [NSDictionary dictionary];
      void (^completion)(BOOL success) = ^void(BOOL success) {
        NSLog(@"completion for openURL: %i", success);
      };
      [invocation setTarget:responder];
      [invocation setSelector:selectorOpenURL];
      [invocation setArgument:&url atIndex:2];
      [invocation setArgument:&options atIndex:3];
      [invocation setArgument:&completion atIndex:4];
      [invocation invoke];
      break;
    }
  }
}

- (void)callOpenbookAppWithData:(NSDictionary*)data {
  NSFileManager* manager = [NSFileManager defaultManager];
  NSError* error;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
  // TODO: handle error
  NSString* tempPath = [self getTempDir];
  NSString* jsonFile = [self getTempFileWithExtension:@"json"];
  if (![manager createFileAtPath:[tempPath stringByAppendingPathComponent:jsonFile] contents:jsonData attributes:nil]) {
    // TODO: handle error
  }
  // call main app
  [self callOpenbookAppWithSharedFileName:jsonFile];
  // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (void)didSelectPost {
  // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
  NSFileManager* manager = [NSFileManager defaultManager];
  NSExtensionContext* context = self.extensionContext;
  // As we have to communicate text and an image to the app, write everything to a file instead of putting everything in an URL.
  NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
  args[@"text"] = self.contentText;
  // Handle an image
  BOOL hasCallback = NO;
  NSArray* items = context.inputItems;
  if ([items count] >= 1) {
    NSExtensionItem* item = items[0];
    if ([item.attachments count] >= 1) {
      NSItemProvider* itemProvider = item.attachments[0];
      if ([itemProvider hasItemConformingToTypeIdentifier:@"public.image"]) {
        hasCallback = YES;
        [itemProvider loadItemForTypeIdentifier:@"public.image" options:nil completionHandler:^void(UIImage* image, NSError* error) {
          // TODO: handle error
          NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
          if (imageData == nil){
            // TODO: handle error
          }
          NSString* tempPath = [self getTempDir];
          NSString* fileName = [self getTempFileWithExtension:@"jpg"];
          if (![manager createFileAtPath:[tempPath stringByAppendingPathComponent:fileName] contents:imageData attributes:nil]) {
            // TODO: handle error
          }
          args[@"path"] = [tempPath stringByAppendingPathComponent:fileName];
          [self callOpenbookAppWithData:args];
        }];
      }
    }
  }

  // If we have a callback (when loading an image), do not immediately open the app, that will happen in the callback
  if (!hasCallback) {
    [self callOpenbookAppWithData:args];
  }
}

- (NSArray *)configurationItems {
  // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
  return @[];
}

@end
