//
//  StampAgeController.m
//  TheMusicCamera
//
//  Created by yanglei on 14-1-6.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "StampAgeController.h"
#import "AgeUtil.h"

@interface StampAgeController ()
{
  int year ;
  int month;
  int stampItem ;
}

@end

@implementation StampAgeController
@synthesize scrollView;
@synthesize age;
@synthesize demoView;
@synthesize delegate;

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
  
  
  int right_margin = 30;
  for (int i = 1; i <= 8 ; ++ i)
  {
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d.png",i]]];
    
    [scrollView addSubview:icon];
    CGRect rect = icon.frame;
    rect.origin.x = right_margin;
    
    rect.size.width = rect.size.width/2;
    rect.size.height = rect.size.height/2;
    rect.origin.y = (scrollView.frame.size.height - rect.size.height)/2;
    icon.frame = rect;
    
    UIButton* icon_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    icon_btn.frame = rect;
    icon_btn.tag = 30 + i;
    [icon_btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:icon_btn];
    
    [scrollView addSubview:icon_btn];
    
    right_margin += rect.size.width + 30;
  }
  
  [scrollView setContentSize:CGSizeMake(right_margin, 160)];

  year = 0 ;
  month = 0;
  stampItem = 0;
}

-(void) selectItem:(UIButton*)sender
{
  stampItem = sender.tag-30;
  [self setAgeImage];
}

-(void) setAgeImage
{
  demoView.image = nil;
  UIImage* result= [AgeUtil generateAgeStampImage:stampItem andYear:year andMonth:month];
//  UIImage* result = [UIImage imageWithCGImage:image.CGImage scale:image.scale*0.1 orientation:image.imageOrientation];
  demoView.image = result;
  CGRect rect = demoView.frame;
  rect.size = result.size;
  rect.origin.x = (320 - result.size.width)/2;
  demoView.frame = rect;
}

-(void) okBtn:(id) sender
{
  if (year >= 0 && month >= 0)
  {
    [delegate finishSetAge:demoView.image];
    [self.navigationController popViewControllerAnimated:YES];
  }
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

-(void) didFinishSetAge:(int)_year andMonth:(int)_month
{
  year = _year;
  month = _month;
 age.text = [NSString stringWithFormat:@"%d歳 %dか月",year,month];
  [self setAgeImage];
}

-(IBAction)ageClick:(id)sender
{
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"stamp_age" bundle:nil];
  SetAgeViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"SetAgeViewController"];
  controller.delegate = self;
  [self.navigationController pushViewController:controller animated:YES];

}

@end
