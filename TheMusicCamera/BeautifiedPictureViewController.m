//
//  BeautifiedPictureViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "BeautifiedPictureViewController.h"
#import "WaterImageController.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface BeautifiedPictureViewController ()
{
  GKImagePicker *picker;
}
@end

@implementation BeautifiedPictureViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
    [UIApplication sharedApplication].statusBarHidden=YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
  
  imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
  [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelClick:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
}

-(IBAction) useClick:(id)sender
{
  
 
}
-(IBAction) changeSize:(id)sender
{

}
-(void) begin
{
  if (picker == nil) {
    picker = [[GKImagePicker alloc] init];
    picker.delegate = self;
    picker.cropper.cropSize = CGSizeMake(320,320.);   // (Optional) Default: CGSizeMake(320., 320.)
    picker.cropper.rescaleImage = YES;                // (Optional) Default: YES
    picker.cropper.rescaleFactor = 2.0;               // (Optional) Default: 1.0
    picker.cropper.dismissAnimated = YES;              // (Optional) Default: YES
    picker.cropper.overlayColor = [UIColor clearColor];//[UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7];  // (Optional) Default: [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7]
    picker.cropper.innerBorderColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.7];   // (Optional) Default: [UIColor colorWithRed:0/255. green:0/255. blue:0/255. alpha:0.7]
  }
  [picker presentPicker];
}

-(void) imagePickerDidFinish:(GKImagePicker *)imagePicker withImage:(UIImage *)image
{
  imageView.image = image;
}
@end
