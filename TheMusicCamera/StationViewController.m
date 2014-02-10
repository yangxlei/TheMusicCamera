//
//  StationViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-23.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "StationViewController.h"
#import "DataManager.h"

@interface StationViewController ()

@end

@implementation StationViewController

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
//    [self navgationImage:@"header_sound_btn"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_sound_btn",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];

    self.hidesBottomBarWhenPushed = YES;

}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftBtn:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"musicstation"];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)rightBtn:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"musicstation"];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
