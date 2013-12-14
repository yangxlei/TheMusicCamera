//
//  CameraController.m
//  TheMusicCamera
//
//  Created by yanglei on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController
@synthesize backBtn;
@synthesize flashBtn;
@synthesize kirikaeBtn;
@synthesize sizeBtn;
@synthesize cameraBtn;
@synthesize cameraView;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
