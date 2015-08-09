//
//  GallaryVC.h
//  zooming
//
//  Created by mac on 27/04/1937 SAKA.
//  Copyright (c) 1937 SAKA grr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomingView.h"
#import "AsyncImageView.h"

@interface GallaryVC : UIViewController<UIScrollViewDelegate>{
    
    NSInteger indexCurrentImage;
    ZoomingView *zoomingView;
    
     UIButton *btnClose;
     UIView   *topView;
    CGRect applicationFrame;
}
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *arrImages;
@property (nonatomic, strong) NSMutableArray *arrImagesViews;




@end
