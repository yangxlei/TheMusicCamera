//
//  ShareViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ShareViewController.h"
#import "DataManager.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

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
    [self navgationImage:@"header_share"];
    
    UIButton *btn = [self navgationButton:@"button_top" andFrame:CGRectMake(250, 10, 60, 28)];
    [btn addTarget:self action:@selector(topBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)topBtuuon
{
    NSLog(@"topBtuuon");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];

}

@end
