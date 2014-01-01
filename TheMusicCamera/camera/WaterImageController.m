//
//  WaterImageController.m
//  TheMusicCamera
//
//  Created by yanglei on 13-12-26.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "WaterImageController.h"

@interface WaterImageController ()

@end

@implementation WaterImageController
@synthesize imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) setSourceImage:(UIImage *)img
{
  sourceImg = img;
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  CGRect rect =  imageview.frame;
  rect.size = sourceImg.size;
  imageview.frame = rect;
  imageview.image = sourceImg;
  imageview.center = self.view.center;
  self.navigationController.navigationBarHidden = NO;
  
}

-(void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
