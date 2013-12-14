//
//  SoundsRecordViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRecordViewController.h"
#import "DataManager.h"

@interface SoundsRecordViewController ()

@end

@implementation SoundsRecordViewController

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
    
    self.hidesBottomBarWhenPushed = YES;

    [self navgationImage:@"header_recording"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveBtn = [self navgationButton:@"button_save" andFrame:CGRectMake(260, 10, 52, 28)];
    [saveBtn addTarget:self action:@selector(saveBtuuon) forControlEvents:UIControlEventTouchUpInside];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtuuon
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtuuon
{
    
}

@end
