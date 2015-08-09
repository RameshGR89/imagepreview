#import <Cordova/CDV.h>
#import "GallaryVC.h"
#import "GallaryVC2.h"

@interface ImagePreview : CDVPlugin

- (void) greet:(CDVInvokedUrlCommand*)command;
- (void) openGallary:(CDVInvokedUrlCommand*)command;
- (void) closeGallary:(CDVInvokedUrlCommand*)command;

@end