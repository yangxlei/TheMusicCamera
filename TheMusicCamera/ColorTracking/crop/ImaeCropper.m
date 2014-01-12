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
  UIImageOrientation orientation;
}

@end

@implementation ImaeCropper
@synthesize delegate;

-(id) initWithImage:(UIImage *)image
{
  self = [super init];
  if(self)
  {
    orientation = image.imageOrientation;
    image = [UIImage imageWithCGImage:image.CGImage scale:1.0f orientation:UIImageOrientationUp];
    
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
    
    UIButton* cropBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(250, 10, 62, 31)];
    [cropBtn addTarget:self action:@selector(cropBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton* changebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-45, 60, 40)];
//    changebtn.backgroundColor = [UIColor redColor];
//    changebtn.titleLabel.textColor = [UIColor whiteColor];
//    [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
//      [changebtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [changebtn addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:changebtn];
    
      
      onebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-45, 28, 28)];
//      onebtn.backgroundColor = [UIColor redColor];
      onebtn.titleLabel.textColor = [UIColor whiteColor];
//      [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
      [onebtn setImage:[UIImage imageNamed:@"trimming_1_1_off"] forState:UIControlStateNormal];
      [onebtn setImage:[UIImage imageNamed:@"trimming_1_1_on"] forState:UIControlStateSelected];
      [onebtn addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
      onebtn.selected = YES;
      [self.view addSubview:onebtn];

      fourbtn = [[UIButton alloc] initWithFrame:CGRectMake(48, self.view.frame.size.height-45, 28, 35)];
//      fourbtn.backgroundColor = [UIColor redColor];
      fourbtn.titleLabel.textColor = [UIColor whiteColor];
//      [changebtn setTitle:@"4:3" forState:UIControlStateNormal];
      [fourbtn setImage:[UIImage imageNamed:@"trimming_4_3_off"] forState:UIControlStateNormal];
      [fourbtn setImage:[UIImage imageNamed:@"trimming_4_3_on"] forState:UIControlStateSelected];
      [fourbtn addTarget:self action:@selector(changeSize:) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:fourbtn];

      sizeFlag = NO;
//    self.view.backgroundColor = [UIColor colorWithRed:112/255 green:83/255 blue:87/255 alpha:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
  }
  
  return self;
}

-(void) changeSize:(UIButton*) sender
{
  if (sizeFlag)
  {
      sizeFlag = NO;
      onebtn.selected = YES;
      fourbtn.selected = NO;

    [mask setCropSize:CGSizeMake(300, 300)];
//    [sender setTitle:@"4:3" forState:UIControlStateNormal];
  }
  else
  {
      sizeFlag = YES;
      onebtn.selected = NO;
      fourbtn.selected = YES;

    [mask setCropSize:CGSizeMake(300, 400)];
//    [sender setTitle:@"1:1" forState: UIControlStateNormal];
  }

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

  UIImage* result = [UIImage imageWithCGImage:cropped.CGImage scale:1.0f orientation: orientation];
  return result;
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
    if (sizeFlag) {//4:3
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:3] forKey:@"imageSize"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"imageSize"];
    }

    [self.navigationController popViewControllerAnimated:YES];
  [delegate didCropImage:[self cropImage]];
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
