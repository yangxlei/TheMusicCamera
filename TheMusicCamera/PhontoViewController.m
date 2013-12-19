//
//  PhontoViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "PhontoViewController.h"
#import "Public.h"

@interface PhontoViewController ()

@end

@implementation PhontoViewController

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
    self.navigationController.navigationBarHidden = YES;
    
    soundsOff = YES;
    
    backImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    if (iPhone5) {
        backImage.image = [UIImage imageNamed:@"mama_camera_top_1136.png"];
    }
    else
    {
        backImage.image = [UIImage imageNamed:@"mama_camera_top_960.png"];

    }
    
    [self.view insertSubview:backImage atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)soundsBtn:(id)sender {
    if (soundsOff) {
        soundsOff = NO;
        [sender setImage:[UIImage imageNamed:@"sleep_mode_on"] forState:UIControlStateNormal];
    }
    else
    {
        soundsOff = YES;
        [sender setImage:[UIImage imageNamed:@"sleep_mode_off"] forState:UIControlStateNormal];
    }
}

@end
