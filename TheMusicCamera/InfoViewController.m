//
//  InfoViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-23.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "InfoViewController.h"
#import "DataManager.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
//    [self navgationImage:@"header_info"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_info",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

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

@end
