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
#import "DataManager.h"

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
//[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicstation"];

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"musicstation"]intValue]==1) {
        stationLab.text = @"左";
    }
    else
    {
        stationLab.text = @"右";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self navgationImage:@"header_sound_setting"];

    dataManager = [DataManager sharedManager];
    stationLab.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:14];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromSetReturnVC:) name:@"FROMSETRETURNVC" object:nil];

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
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ママカメラProアップグレード"
                                                       message:@"■録音件数が10件まで可能\n■全スタンプ使用可能\n■全フレーム使用可能\n■全年齢スタンプ使用可能\n■広告バナー削除"
                                                 delegate:self
                                        cancelButtonTitle:@"YES"
                                        otherButtonTitles:@"NO", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"0");
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbp.labelText = @"   购买中,请稍后...   ";
        dataManager.fromNo = 2;

        [[StoreKitHelper shareInstance] getAppstoreLocal];
        
    }
    else
    {
        NSLog(@"1");
    }
}

- (void) fromSetReturnVC: (NSNotification*) aNotification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

@end
