//
//  SoundsViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsViewController.h"
#import "DataManager.h"
#import "Public.h"

@interface SoundsViewController ()

@end

@implementation SoundsViewController

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
    [self navgationImage:@"header_sound_setting"];
    
    if (iPhone5) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 168, 281, 252)];
        image.image = [UIImage imageNamed:@"setting_sound_image_1136"];
        [self.view addSubview:image];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(91, 356, 138, 42);
        [button setBackgroundImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
    }
    else
    {
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
