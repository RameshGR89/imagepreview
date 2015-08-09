//
//  zoomView.m
//  Sample
//
//  Created by mac on 10/05/1937 SAKA.
//
//

#import "zoomView.h"

@implementation zoomView


@synthesize asyncImageView;

@synthesize imageScrollView;

@synthesize imageIndex;

@synthesize imageURL;
@synthesize imageSource;
@synthesize delegate;
@synthesize isZoomEffect;
@synthesize activityIndicator;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setZoomViewConfig:(CGRect)frame{
    isZoomEffect=NO;
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview: activityIndicator];
        
    }
    
    
    
    

    imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageScrollView.backgroundColor=[UIColor blackColor];
    imageScrollView.delegate=self;
     NSLog(@"imageURL -->%@",imageURL);
    asyncImageView = [[AsyncImageView alloc] initWithFrame:imageScrollView.frame];
   // asyncImageView.imageURL =imageURL;
    
    if (imageSource) {
        asyncImageView.image=imageSource;
        asyncImageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f),.size=imageSource.size};
        
        // Tell the scroll view the size of the contents
        imageScrollView.contentSize = imageSource.size;
        [activityIndicator stopAnimating];
    }else{
        [[AsyncImageLoader sharedLoader] loadImageWithURL:imageURL target:self success:@selector(setImage:) failure:@selector(setImageLoadingFailure:)];
        
        asyncImageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f),.size=asyncImageView.frame.size};
        
        // Tell the scroll view the size of the contents
        imageScrollView.contentSize = asyncImageView.frame.size;
        [self bringSubviewToFront:activityIndicator];
        [activityIndicator startAnimating];
    }
    
    
    NSLog(@"asyncImageView.image data -->%@",asyncImageView.image);
    asyncImageView.contentMode = UIViewContentModeScaleAspectFit;
    asyncImageView.clipsToBounds = YES;
    asyncImageView.backgroundColor=[UIColor blackColor];

    asyncImageView.layer.borderWidth=1.0f;
    asyncImageView.layer.borderColor = [UIColor clearColor].CGColor;
    [imageScrollView addSubview:asyncImageView];
    
    [self addSubview:imageScrollView];
    self.backgroundColor=[UIColor blueColor];
    [self setScrollviewConstraint];

    // Add doubleTap recognizer to the scrollView
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.imageScrollView addGestureRecognizer:singleTapRecognizer];
    
    // Add doubleTap recognizer to the scrollView
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.imageScrollView addGestureRecognizer:doubleTapRecognizer];
    if (!imageSource) {
        [self bringSubviewToFront:activityIndicator];
    }
    
    
}
-(void)removeScrollView{
    
    [activityIndicator stopAnimating];
    [asyncImageView removeFromSuperview];
    [imageScrollView removeFromSuperview];
    imageScrollView=nil;
    asyncImageView=nil;
    
}
-(void)restImageView{
    isZoomEffect=NO;
    
    asyncImageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f),.size=imageSource.size};
    asyncImageView.contentMode = UIViewContentModeScaleAspectFit;
    asyncImageView.clipsToBounds = YES;
    
    // Tell the scroll view the size of the contents
    imageScrollView.contentSize = imageSource.size;
    
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = imageScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / imageScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / imageScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    imageScrollView.minimumZoomScale = minScale;
    imageScrollView.maximumZoomScale = 5.0f;
    imageScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}
    
-(void)setImage:(UIImage*)image{
    
    [activityIndicator stopAnimating];
    NSLog(@"image -->%@",image);
    asyncImageView.image =image;
    imageSource= image;
    [self restImageView];
}
-(void)setImage:(NSInteger )index  URL:(NSURL *)imageurl{
    
   // imageScrollView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if (asyncImageView.image) {
        [activityIndicator stopAnimating];
        CGFloat newZoomScale = imageScrollView.zoomScale * 2.5f;
        newZoomScale = MIN(newZoomScale, imageScrollView.maximumZoomScale);
        NSLog(@"newZoomScale--%f",newZoomScale);
        if (isZoomEffect==YES) {
            [self removeScrollView];
            [self setZoomViewConfig:self.frame];
            [self restImageView];
            isZoomEffect=NO;
        }
        
    }else{
        [activityIndicator startAnimating];
       [[AsyncImageLoader sharedLoader] loadImageWithURL:imageurl target:self success:@selector(setImage:) failure:@selector(setImageLoadingFailure:)];
    }
    
}

-(void)setImageLoadingFailure:(NSError *)error{
    NSLog(@"setImageLoadingFailure: Error--%@",error);
}

- (void)centerScrollViewContents {
    CGSize boundsSize = imageScrollView.bounds.size;
    CGRect contentsFrame = asyncImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }

    asyncImageView.frame = contentsFrame;
}
-(void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer {
    
    [self.delegate scrollViewSingleTap:self];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    isZoomEffect=YES;
    [self.delegate scrollViewDoubleTappes:self];
    [self.delegate showTopViewOption:NO];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    
    CGFloat newZoomScale = imageScrollView.zoomScale * 2.5f;
    newZoomScale = MIN(newZoomScale, imageScrollView.maximumZoomScale);
    NSLog(@"newZoomScale--%f",newZoomScale);
    if (newZoomScale>=5) {
        [self removeScrollView];
        [self setZoomViewConfig:self.frame];
        [self restImageView];
        isZoomEffect=NO;
    }else{
        NSLog(@"imageScrollView.maximumZoomScale--%f",imageScrollView.maximumZoomScale);
        
        
        // Get the location within the image view where we tapped
        CGPoint pointInView = [recognizer locationInView:self.asyncImageView];
        
        // Figure out the rect we want to zoom to, then zoom to it
        CGSize scrollViewSize = imageScrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        [imageScrollView zoomToRect:rectToZoomTo animated:YES];
    }

}


-(void) setScrollviewConstraint{
    
    // Width constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageScrollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Height constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageScrollView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    
    // Center horizontally
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageScrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0.0]];
    
    // Center vertically
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageScrollView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0.0]];
    
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return asyncImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    isZoomEffect=YES;
}
@end
