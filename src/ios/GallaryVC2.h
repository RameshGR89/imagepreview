//
//  GallaryVC2.h
//  Sample
//
//  Created by mac on 10/05/1937 SAKA.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "zoomView.h"

@class zoomView;

@interface GallaryVC2 : UIViewController <UIScrollViewDelegate,zoomViewDelegate>
{
    UIButton *btnClose;
    UIButton *btnSave;
    UIView   *topView;
    CGRect applicationFrame;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *arrImages;
@property (nonatomic, strong) NSMutableArray *arrImagesViews;
@property (nonatomic, assign) NSInteger indexCurrentImage;
@end
