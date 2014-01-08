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
#import "ExplanationViewController.h"
#import "StoreKitHelper.h"

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

- (IBAction)explanationBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ExplanationViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ExplanationViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)inappStore:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                  message:@"这是一个简单的警告框！"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:@"取消", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"0");
        StoreKitHelper *store = [[StoreKitHelper alloc]init];
        [store buyItemWithType:0];
        
    }
    else
    {
        NSLog(@"1");
    }
}
@end
