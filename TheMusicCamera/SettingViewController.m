//
//  SettingViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SettingViewController.h"
#import "DataManager.h"
#import "StationViewController.h"
#import "InfoViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    StationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"StationViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)infoBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    InfoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
