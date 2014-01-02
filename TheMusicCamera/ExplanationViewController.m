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
    currentPage = 0;
    
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
    if (currentPage>=1) {
        currentPage--;
//        [scrollView setContentOffset:CGPointMake(320*currentPage, 0)];
        [scrollView scrollRectToVisible:CGRectMake(320*currentPage,0,320,568) animated:YES];

    }
}

- (IBAction)nestBtn:(id)sender
{
    if (currentPage<=2) {
        currentPage++;
        [scrollView scrollRectToVisible:CGRectMake(320*currentPage,0,320,568) animated:YES];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"currentPage  %d",currentPage);
    
    
}

@end
