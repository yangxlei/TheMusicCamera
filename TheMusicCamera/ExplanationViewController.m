//
//  ExplanationViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-30.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "ExplanationViewController.h"
#import "DataManager.h"

@interface ExplanationViewController ()

@end

@implementation ExplanationViewController

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
    
    UIButton *btn = [self navgationButton:@"info_close" andFrame:CGRectMake(10, 7, 33, 33)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];

    for (int i=0; i<4; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*320, 0, 320, 568)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"howTo_0%d.png",i+1]];
        [scrollView addSubview:imageV];
    }
    scrollView.contentSize =CGSizeMake(320*4, 568);
    scrollView.delegate = self;
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

- (IBAction)previousBtn:(id)sender
{
    
}

- (IBAction)nestBtn:(id)sender
{
    
}
@end
