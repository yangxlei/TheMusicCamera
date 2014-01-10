//
//  StampAgeController.m
//  TheMusicCamera
//
//  Created by yanglei on 14-1-6.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "StampAgeController.h"

@interface StampAgeController ()

@end

@implementation StampAgeController
@synthesize scrollView;
@synthesize age;
@synthesize demoView;

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

  [self navgationImage:@"header_age_stamp.png"];
  
  UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
  [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *editBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(250, 10, 62, 31)];
  [editBtn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
  
  UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(26, 15, 154, 154)];
  icon.image = [UIImage imageNamed:@"stamp_age_1.png"];
  [scrollView addSubview:icon];

}

-(void) okBtn:(id) sender
{

}

-(void) backBtuuon
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ageClick:(id)sender
{

}

@end
