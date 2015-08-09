//
//  GallaryVC.m
//  zooming
//
//  Created by mac on 27/04/1937 SAKA.
//  Copyright (c) 1937 SAKA grr. All rights reserved.
//

#import "GallaryVC.h"

@interface GallaryVC ()

@end

@implementation GallaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    [self setScrollViewConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnCloseAvtion:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    
    NSLog(@"scrollView.conf x=%F",scrollView.contentOffset.x);
    // First, determine which page is currently visible
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    indexCurrentImage=page;
    NSLog(@"page =%ld",(long)indexCurrentImage);
    NSLog(@"Image URL =%@",[self.arrImages objectAtIndex:indexCurrentImage]);
}
-(void)setScrollViewConfig{
    
    self.mainScrollView=[[UIScrollView alloc]initWithFrame:applicationFrame];
    self.mainScrollView.backgroundColor=[UIColor blackColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.pagingEnabled=YES;
    
    topView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, applicationFrame.size.width, 80)];
    //topView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    topView.backgroundColor= [UIColor clearColor];
    
    btnClose=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    btnClose.backgroundColor=[UIColor clearColor];
    [btnClose setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseAvtion:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btnClose];
    [self.view addSubview:topView];
    [self setTopviewConstraint];
    
    topView.hidden=YES;
    
    NSInteger intXpos=applicationFrame.size.width;
    
    
    self.arrImagesViews=[[NSMutableArray alloc]init];
    indexCurrentImage=0;
    self.mainScrollView.scrollEnabled=YES;

    NSLog(@"self.arrImages count = %lu",(unsigned long)self.arrImages.count);


    for (int i=0; i<[self.arrImages count]; i++)
    {
        
        AsyncImageView *imgView = [[AsyncImageView alloc]initWithFrame:CGRectMake((i*intXpos)+10, 2, applicationFrame.size.width-20, applicationFrame.size.height)];

        NSString* escapedUrlString =
        [[[self.arrImages objectAtIndex:i]objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:
         NSUTF8StringEncoding];

        imgView.imageURL =[NSURL URLWithString:escapedUrlString];
         
        //imgView.image = [self.arrImages objectAtIndex:i];

        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.clipsToBounds = YES;
        imgView.backgroundColor=[UIColor clearColor];
        [imgView setTag:i];
        [self.mainScrollView addSubview:imgView];
        
        // Add doubleTap recognizer to the scrollView
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
        singleTapRecognizer.numberOfTapsRequired = 1;
        [self.mainScrollView addGestureRecognizer:singleTapRecognizer];
        
        // Add doubleTap recognizer to the scrollView
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        
        // Add pinchGestureRecognizer recognizer to the scrollView
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewpinchGesture:)];
        [self.mainScrollView addGestureRecognizer:pinchGestureRecognizer];
        
        [self.mainScrollView addGestureRecognizer:doubleTapRecognizer];
        [self.arrImagesViews addObject:imgView];
    }
    
    self.mainScrollView.contentSize=CGSizeMake([self.arrImages count]*applicationFrame.size.width, 0);
    [self.view addSubview:self.mainScrollView];
    [self setScrollviewConstraint];
    
}
-(void) setScrollviewConstraint{
    
    // Width constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mainScrollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Height constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mainScrollView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    
    // Center horizontally
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mainScrollView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0.0]];
    
    // Center vertically
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mainScrollView
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
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}
#pragma mark -
#pragma mark - ScrollView gesture methods
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.mainScrollView];
    
    NSLog(@"pointInView X=%f Y=%f",pointInView.x,pointInView.y);
    
    NSLog(@"page =%ld",(long)indexCurrentImage);
    
    [self openZoomView];
}
-(void)scrollViewpinchGesture:(UIPinchGestureRecognizer*)recognizer {
    [self openZoomView];
    topView.hidden=NO;
}
-(void)openZoomView{
    if (zoomingView) {
        zoomingView=nil;
    }
    topView.hidden=YES;
    zoomingView =[[ ZoomingView alloc] initWithNibName:@"ZoomingView" bundle:nil];
    
    AsyncImageView *imgView     =   [self.arrImagesViews objectAtIndex:indexCurrentImage];
    zoomingView.mainImage       =   imgView.image;
    [self presentViewController:zoomingView animated:NO completion:nil];
}

- (void)scrollViewSingleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.mainScrollView];
    
    NSLog(@"pointInView X=%f Y=%f",pointInView.x,pointInView.y);
    
    NSLog(@"page =%ld",(long)indexCurrentImage);

    
    [self.view bringSubviewToFront:topView];
    
    topView.hidden=NO;
    
    
       
    NSLog(@"pointInView X=%f Y=%f",pointInView.x,pointInView.y);
    
    NSLog(@"page =%ld",(long)indexCurrentImage);
    
   [self openZoomView];
    topView.hidden=NO;
}




@end
