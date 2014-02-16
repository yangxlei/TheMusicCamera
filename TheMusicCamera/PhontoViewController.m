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
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOFF"] integerValue]==1) {
        soundsOff = YES;
    }
    else
    {
        soundsOff = NO;
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSLog( @"currentLanguage====   %@" , currentLanguage);
        
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            musicLabel.text = @"安睡模式";
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            musicLabel.text = @"sleeping mode";
        }
        else
        {
            musicLabel.text = @"おやすみモード";
        }

    }
    
    backImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    if (iPhone5) {

//        backImage.image = [UIImage imageNamed:@"mama_camera_top_1136.png"];
        backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@mama_camera_top_1136",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];
    }
    else
    {
        backImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@mama_camera_top_960",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];
//        backImage.image = [UIImage imageNamed:@"mama_camera_top_960.png"];

    }
    
    [self.view insertSubview:backImage atIndex:0];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarHidden=YES;
    musicLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"musicName"];
    musicLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:14];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOFF"] integerValue]==1) {
        soundsOff = YES;
        [soundBtn setImage:[UIImage imageNamed:@"sleep_mode_off"] forState:UIControlStateNormal];
    }
    else
    {
        soundsOff = NO;
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSLog( @"currentLanguage====   %@" , currentLanguage);
        
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            musicLabel.text = @"安睡模式";
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            musicLabel.text = @"sleeping mode";
        }
        else
        {
            musicLabel.text = @"おやすみモード";
        }
        [soundBtn setImage:[UIImage imageNamed:@"sleep_mode_on"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)soundsBtn:(id)sender {
    if (soundsOff) {
        soundsOff = NO;
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSLog( @"currentLanguage====   %@" , currentLanguage);
        
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            musicLabel.text = @"安睡模式";
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            musicLabel.text = @"sleeping mode";
        }
        else
        {
            musicLabel.text = @"おやすみモード";
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"musicOFF"];
        [sender setImage:[UIImage imageNamed:@"sleep_mode_on"] forState:UIControlStateNormal];
    }
    else
    {
        soundsOff = YES;
        musicLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"musicName"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicOFF"];
        [sender setImage:[UIImage imageNamed:@"sleep_mode_off"] forState:UIControlStateNormal];
    }
}

@end
