//
//  ZoomingView.m
//  zooming
//
//  Created by mac on 27/04/1937 SAKA.
//  Copyright (c) 1937 SAKA grr. All rights reserved.
//

#import "ZoomingView.h"

@interface ZoomingView ()

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation ZoomingView

@synthesize scrollView = _scrollView;

@synthesize imageView = _imageView;


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
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
    
    
    self.imageView.frame = contentsFrame;
}
-(void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer {
     topView.hidden=NO;
    [self.scrollView bringSubviewToFront:topView];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    topView.hidden=YES;
    
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale * 2.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    topView.hidden=YES;
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}
-(void) setScrollviewConstraint{
    
    // Width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0.0]];
    
    // Center vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.scrollView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0.0]];
    
    
}
-(void) setTopviewConstraint{
    
    // Width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:50-(applicationFrame.size.height)]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:20]];
    
    
    [self.view bringSubviewToFront:btnClose];
    
}

-(void)setScrollViewConfig{
    self.scrollView=[[UIScrollView alloc]initWithFrame:applicationFrame];
    self.scrollView.backgroundColor=[UIColor blackColor];
    self.scrollView.delegate=self;
    
    topView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, applicationFrame.size.width, 80)];
    topView.backgroundColor=[UIColor clearColor];
    //topView.layer.opacity=0.4;
    
    btnClose=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    btnClose.backgroundColor=[UIColor clearColor];
    [btnClose setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    
    
    btnSave=[[UIButton alloc]initWithFrame:CGRectMake(topView.frame.size.width-80, 5, 60, 60)];
    btnSave.backgroundColor=[UIColor clearColor];
    [btnSave setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSave:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView    addSubview:btnClose];
    [topView    addSubview:btnSave];
    btnClose.backgroundColor = [UIColor clearColor];
    btnSave.backgroundColor  = [UIColor clearColor];
    

    // Set up the image we want to scroll & zoom and add it to the scroll view
    UIImage *image = _mainImage;
    self.imageView = [[UIImageView alloc] initWithImage:image];
    //self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    
    
    /*AsyncImageView *imageView=[[AsyncImageView alloc]init];
     imageView.imageURL =_imageURL;*/
    
    self.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.imageView];
    
    self.imageView.layer.borderWidth=1.0f;
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    // Tell the scroll view the size of the contents
    self.scrollView.contentSize = _mainImage.size;
    

    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    //doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    [self.view addSubview:self.scrollView];
    [self.view  addSubview:topView];
    [self setTopviewConstraint];
    [self setScrollviewConstraint];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     applicationFrame = [[UIScreen mainScreen] applicationFrame];
    // Set a nice title
    self.title = @"Image";
    [self setScrollViewConfig];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 5.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}*/

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void )btnClose:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)btnSave:(id)sender{
    
    if (_mainImage) {
        btnSave.hidden=YES;
        UIImageWriteToSavedPhotosAlbum(self.mainImage,
                                       self, // send the message to 'self' when calling the callback
                                       @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                       NULL); // you generally won't need a contextInfo here
    }
   
}
    - (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
        if (error) {
            // Do anything needed to handle the error or display it to the user
            btnSave.hidden=NO;
            NSLog(@"error-->%@",error);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Image saved to photogallary not successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            btnSave.hidden=YES;
            // .... do anything you want here to handle
            // .... when the image has been saved in the photo album
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Image Saving" message:@"Image saved to photogallary successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }

@end
