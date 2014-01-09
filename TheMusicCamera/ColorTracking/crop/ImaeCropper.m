//
//  ImaeCropper.m
//  CropImage
//
//  Created by yanglei on 14-1-8.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import "ImaeCropper.h"
#import "CropMask.h"
#import "DataManager.h"

@interface ImaeCropper ()
{
  UIImageView* imageView;
  UIScrollView* scrollView;
  CropMask *mask ;
  
}

@end

@implementation ImaeCropper
@synthesize delegate;

-(id) initWithImage:(UIImage *)image
{
  self = [super init];
  if(self)
  {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 460)];
    scrollView.delegate = self;
    [scrollView setShowsHorizontalScrollIndicator:NO];
		[scrollView setShowsVerticalScrollIndicator:NO];
		[scrollView setMaximumZoomScale:2.0];
    
    imageView = [[UIImageView alloc] initWithImage:image];
    
    [scrollView setContentSize:image.size];
		[scrollView setMinimumZoomScale:[scrollView frame].size.width / image.size.width];
		[scrollView setZoomScale:[scrollView minimumZoomScale]];
		[scrollView addSubview:imageView];
    
    [self.view addSubview:scrollView];
    
    mask = [[CropMask alloc] initWithFrame:CGRectMake(0, 40, 320, 460)];
    [mask setCropSize:CGSizeMake(300, 300)];
    
    [self.view addSubview:mask];
    
    
    [self navgationImage:@"header.png"];
    
    UIButton *btn = [self navgationButton:@"button_back.png" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton* cropBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(260, 10, 52, 28)];
    [cropBtn addTarget:self action:@selector(cropBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* changebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-45, 60, 40)];
    changebtn.backgroundColor = [UIColor redColor];
    changebtn.titleLabel.textColor = [UIColor whiteColor];
    [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
    [changebtn addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changebtn];
    
//    self.view.backgroundColor = [UIColor colorWithRed:112/255 green:83/255 blue:87/255 alpha:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
  }
  
  return self;
}

-(void) changeSize:(UIButton*) sender
{
  if (sizeFlag)
  {
    [mask setCropSize:CGSizeMake(300, 300)];
    [sender setTitle:@"4:3" forState:UIControlStateNormal];
  }
  else
  {
    [mask setCropSize:CGSizeMake(300, 400)];
    [sender setTitle:@"1:1" forState: UIControlStateNormal];
  }
  sizeFlag = !sizeFlag;

}

-(UIView* ) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)_scrollView
{
  CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
  (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
  CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
  (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
  imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                          scrollView.contentSize.height * 0.5 + offsetY);
}

-(UIImage*) cropImage
{
  float zoomScale = 1.0 / [scrollView zoomScale];
  CGRect cropSize = [mask cropRect];
	
	CGRect rect;
  
  UIImage* source = [imageView image];
  
	rect.origin.x = ([scrollView contentOffset].x + 10) * zoomScale;
	rect.origin.y = ([scrollView contentOffset].y + (scrollView.frame.size.height - cropSize.size.height)/2) * zoomScale;
	rect.size.width =  cropSize.size.width* zoomScale;
	rect.size.height = cropSize.size.height * zoomScale;
	
	CGImageRef cr = CGImageCreateWithImageInRect([source CGImage], rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
  
	
	CGImageRelease(cr);

//  UIImage* result = [self rotatedImage:cropped andRotation:1];
  
//  return result;
  return cropped;
}

- (UIImage *)rotatedImage:(UIImage *)imageToRotate andRotation:(int) rotation
{
  CGFloat rotationAngle = rotation * M_PI / 2;
  
  CGSize imageSize = imageToRotate.size;
  // Image size after the transformation
  CGSize absoluteOutputSize = imageToRotate.size;
  UIImage *outputImage = nil;
  
  // Create the bitmap context
  UIGraphicsBeginImageContext(absoluteOutputSize);
  CGContextRef imageContextRef = UIGraphicsGetCurrentContext();
  
  // Set the anchor point to {0.5, 0.5}
  CGContextTranslateCTM(imageContextRef, .5 * absoluteOutputSize.width, .5 * absoluteOutputSize.height);
  
  // Apply rotation
  CGContextRotateCTM(imageContextRef, rotationAngle);
  
  // Draw the current image
  CGContextScaleCTM(imageContextRef, 1.0, -1.0);
  CGContextDrawImage(imageContextRef, (CGRect) {{-(.5 * imageSize.width), -(.5 * imageSize.height)}, imageSize}, imageToRotate.CGImage);
  
  outputImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return outputImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//  UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 400, 60, 30)];
//  [btn setTitle:@"Change" forState:UIControlStateNormal];
//  [btn addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
//  [self.view addSubview:btn];
//  

  
}

-(void) cropBtn:(id)sender
{
  [delegate didCropImage:[self cropImage]];
  [self.navigationController popViewControllerAnimated:NO];
}


-(void) backButton:(id)sender
{
  [delegate onCacnel];
  [self.navigationController popViewControllerAnimated:NO];
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
