//
//  GallaryVC2.m
//  Sample
//
//  Created by mac on 10/05/1937 SAKA.
//
//

#import "GallaryVC2.h"

@interface GallaryVC2 ()

@end



@implementation  GallaryVC2
@synthesize arrImagesViews ;
@synthesize indexCurrentImage ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


-(void)setScrollViewConfig{
    
    self.mainScrollView=[[UIScrollView alloc]initWithFrame:applicationFrame];
    self.mainScrollView.backgroundColor=[UIColor blackColor];
    self.mainScrollView.delegate=self;
    self.mainScrollView.pagingEnabled=YES;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        /* Device is iPad */
        topView =[[UIView alloc]initWithFrame:CGRectMake(0, 30, applicationFrame.size.width, 80)];
        btnClose=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
         btnSave=[[UIButton alloc]initWithFrame:CGRectMake(topView.frame.size.width-75, 5, 60, 60)];
        
    }else{
        topView =[[UIView alloc]initWithFrame:CGRectMake(0, 20, applicationFrame.size.width, 50)];
        btnClose=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        btnSave=[[UIButton alloc]initWithFrame:CGRectMake(topView.frame.size.width-45, 5, 40,40)];
    }
    
    
    topView.backgroundColor= [UIColor clearColor];
    btnClose.backgroundColor=[UIColor clearColor];
    [btnClose setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnCloseAvtion:) forControlEvents:UIControlEventTouchUpInside];
    btnSave.backgroundColor=[UIColor clearColor];
    [btnSave setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(btnSave:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView    addSubview:btnClose];
    [topView    addSubview:btnSave];
    btnClose.backgroundColor = [UIColor clearColor];
    btnSave.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:topView];
    [self setTopviewConstraint];
    
    topView.hidden=YES;
    
    NSInteger intXpos=applicationFrame.size.width;
    self.arrImagesViews=[[NSMutableArray alloc]init];
   
    self.mainScrollView.scrollEnabled=YES;
    
    arrImagesViews=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[self.arrImages count]; i++)
    {
        zoomView *zoomview=[[zoomView alloc]initWithFrame:CGRectMake((i*intXpos), 0, applicationFrame.size.width, applicationFrame.size.height)];
        zoomview.delegate = self;
        NSString* escapedUrlString =[[[self.arrImages objectAtIndex:i]objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:
         NSUTF8StringEncoding];
        zoomview.imageURL =  [NSURL URLWithString:escapedUrlString];
        zoomview.imageIndex = i;
        [zoomview setZoomViewConfig:applicationFrame];
        
        [self.mainScrollView addSubview:zoomview];
        [arrImagesViews addObject:zoomview];
    }
    
    self.mainScrollView.contentSize=CGSizeMake([self.arrImages count]*applicationFrame.size.width, 0);
    [self.view addSubview:self.mainScrollView];
    [self setScrollviewConstraint];
    if (indexCurrentImage>0) {
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.size.width*indexCurrentImage, 0.0f) animated:NO];
    }else{
         indexCurrentImage=0;
    }
   

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

#pragma mark-
#pragma mark- UIScrollview Delegates


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollView.conf x=%F",scrollView.contentOffset.x);
    // First, determine which page is currently visible
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    NSLog(@"page =%ld",(long)indexCurrentImage);
    NSLog(@"Image URL =%@",[self.arrImages objectAtIndex:indexCurrentImage]);
    
    topView.hidden=YES;
    
    if ([arrImagesViews count]>0) {
        
        if (page!=indexCurrentImage) {
            indexCurrentImage=page;
            if ([[arrImagesViews objectAtIndex:page] isKindOfClass:[zoomView class]]) {
                zoomView *zoomview = [arrImagesViews objectAtIndex:page];
                NSString* escapedUrlString =[[[self.arrImages objectAtIndex:page]objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:
                                             NSUTF8StringEncoding];
                zoomview.imageURL =  [NSURL URLWithString:escapedUrlString];
                [zoomview setImage:page URL:[NSURL URLWithString:escapedUrlString]];
                
            }
        }
        
        
    }
}

#pragma mark -
#pragma mark - ScrollView gesture methods

-(void)showTopViewOption:(BOOL)show{
    if (show) {
        topView.hidden=NO;
    }else{
        topView.hidden=YES;
    }
}

-(void)scrollViewSingleTap:(UIView *)zoomview{
    // Get the location within the image view where we tapped
    NSLog(@"page =%ld",(long)indexCurrentImage);
    
    if ([arrImagesViews count]>0) {
        
        if ([[arrImagesViews objectAtIndex:indexCurrentImage] isKindOfClass:[zoomView class]]) {
            zoomView *zoomview = [arrImagesViews objectAtIndex:indexCurrentImage];
            
            if (zoomview.imageSource) {
                btnSave.hidden=NO;
            }else{
                btnSave.hidden=YES;
            }
        }
    }
    if (topView.hidden) {
        [self.view bringSubviewToFront:topView];
        topView.hidden=NO;
    }else{
        topView.hidden=YES;
    }
}

-(void)scrollViewDoubleTappes:(UIView *)zoomview{
    
}

#pragma mark-
#pragma mark- Image saving to Device PhotoGallary
-(void)btnSave:(id)sender{

    NSLog(@"Image URL =%@",[self.arrImages objectAtIndex:indexCurrentImage]);
    
    if ([arrImagesViews count]>0) {

            if ([[arrImagesViews objectAtIndex:indexCurrentImage] isKindOfClass:[zoomView class]]) {
                zoomView *zoomview = [arrImagesViews objectAtIndex:indexCurrentImage];
                
                if (zoomview.imageSource) {
                    btnSave.hidden=YES;
                    UIImageWriteToSavedPhotosAlbum(zoomview.imageSource,
                                                   self, // send the message to 'self' when calling the callback
                                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                                   NULL); // you generally won't need a contextInfo here
                }
            }
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
        btnSave.hidden=NO;
        // .... do anything you want here to handle
        // .... when the image has been saved in the photo album
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Image Saving" message:@"Image saved to photogallary successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end

