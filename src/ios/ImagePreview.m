#import "ImagePreview.h"

@implementation ImagePreview

- (void)greet:(CDVInvokedUrlCommand*)command
{

    NSString* callbackId = [command callbackId];
    NSString* name = [[command arguments] objectAtIndex:0];
    NSString* msg = [NSString stringWithFormat: @"Hello, %@", name];

    CDVPluginResult* result = [CDVPluginResult
                               resultWithStatus:CDVCommandStatus_OK
                               messageAsString:msg];

    [self success:result callbackId:callbackId];
}

- (void)openGallary:(CDVInvokedUrlCommand*)command{
    
    NSString* callbackId = [command callbackId];

    NSArray* arrImages = [[command arguments] objectAtIndex:0];
    
   // NSUInteger currentIndex= [[command arguments] objectAtIndex:1];
    
    NSLog(@"arrImages==%@",arrImages);
     //NSLog(@"arrImages==%@",[[command arguments] objectAtIndex:1]);


    GallaryVC2 *preview2 =[[ GallaryVC2 alloc] initWithNibName:@"GallaryVC2" bundle:nil];
    preview2.arrImages=arrImages;
    preview2.indexCurrentImage =5;
    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootVC presentViewController:preview2 animated:YES completion:nil];
    
   
}
- (void) closeGallary:(CDVInvokedUrlCommand*)command{
    
}

@end