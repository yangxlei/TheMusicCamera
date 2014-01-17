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
#import "SoundsListViewController.h"
#import "SoundsRepeatViewController.h"
#import "SoundsRecordListViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden=YES;
    soundsName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"musicName"];
    soundsName.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:14];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"musicrepeat"]intValue]==1) {
        repeatName.text = [NSString stringWithFormat:@"あり"];
    }
    else{
        repeatName.text = [NSString stringWithFormat:@"なし"];
    }
    repeatName.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:14];

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
        [button addTarget:self action:@selector(gotoSoundsRecordVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    else
    {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 152, 281, 207)];
        image.image = [UIImage imageNamed:@"setting_sound_image_960"];
        [self.view addSubview:image];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(91, 305, 138, 42);
        [button setBackgroundImage:[UIImage imageNamed:@"recording_button"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(gotoSoundsRecordVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        

    }
    fadeImage = [[UIImageView alloc]initWithFrame:CGRectMake(33, 180, 254, 209)];
    fadeImage.image = [UIImage imageNamed:@"recording_popup"];
    [self.view addSubview:fadeImage];
    fadeImage.alpha = 0;
    
    
}

- (void)gotoSoundsRecordVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SoundsRecordViewController *srVC = [storyboard instantiateViewControllerWithIdentifier:@"SoundsRecordViewController"];
    srVC.delegate = self;
    [self.navigationController pushViewController:srVC animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recordDelegateEvent
{
    
    [UIView setAnimationRepeatCount:1];
    [UIView animateWithDuration:1.0
                     animations:^{[fadeImage setAlpha:1];}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:2.0 animations:^{[fadeImage setAlpha:0];}];}];
}

- (IBAction)gotoSoundsList:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SoundsListViewController *slVC = [storyboard instantiateViewControllerWithIdentifier:@"SoundsListViewController"];
    [self.navigationController pushViewController:slVC animated:YES];
}

- (IBAction)gotoRepeatVC:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SoundsRepeatViewController *spVC = [storyboard instantiateViewControllerWithIdentifier:@"SoundsRepeatViewController"];
    [self.navigationController pushViewController:spVC animated:YES];
}

- (IBAction)gotoSoundsRecordList:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SoundsRecordListViewController *spVC = [storyboard instantiateViewControllerWithIdentifier:@"SoundsRecordListViewController"];
    [self.navigationController pushViewController:spVC animated:YES];

}
@end
