//
//  zoomView.h
//  Sample
//
//  Created by mac on 10/05/1937 SAKA.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol zoomViewDelegate <NSObject>

-(void)showTopViewOption:(BOOL)show;
-(void)scrollViewDoubleTappes:(UIView *)zoomview;
-(void)scrollViewSingleTap:(UIView *)zoomview;

@end


@interface zoomView : UIView<UIScrollViewDelegate>

@property (weak) id <zoomViewDelegate> delegate;

@property(strong, nonatomic) AsyncImageView *asyncImageView;
@property(assign, nonatomic) NSUInteger imageIndex;
@property(strong, nonatomic) UIScrollView *imageScrollView;
@property(strong, nonatomic) NSURL *imageURL;
@property(strong, nonatomic) UIImage *imageSource;

-(void)setImage:(NSInteger )index  URL:(NSURL *)imageurl;
-(void)setZoomViewConfig:(CGRect)frame;

@property(assign, nonatomic) BOOL isZoomEffect;

@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
