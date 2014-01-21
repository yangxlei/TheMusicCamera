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
  
  demoView.contentMode = UIViewContentModeScaleAspectFit;
  age.userInteractionEnabled = NO;
  age.backgroundColor = [UIColor clearColor];
  age.background = nil;
  age.placeHolderColor = [UIColor colorWithRed:214/255 green:214/255 blue:214/255 alpha:1.f];
  
  UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
  [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *editBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(250, 10, 62, 31)];
  [editBtn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
  
  
  int right_margin = 0;
  int width = (320 - 60) / 2 ;
  int height = (scrollView.frame.size.height - 30) /2 ;
  for (int i = 0; i <= 7 ; ++ i)
  {
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d.png",i+1]]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    
    [scrollView addSubview:icon];
    CGRect rect = icon.frame;
    rect.origin.x = (i % 2)*(width + 20) + 20 + right_margin;
    
    rect.size.width = width;
    rect.size.height = height;
    if (i == 0 || i == 1 || i == 4 || i == 5) {
      rect.origin.y = 10;
    }
    else {
      rect.origin.y = height + 20;
    }
    icon.frame = rect;
    
    UIButton* icon_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    icon_btn.frame = rect;
    icon_btn.tag = 30 + i;
    [icon_btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:icon_btn];
    
    [scrollView addSubview:icon_btn];
    
    right_margin = ((i+1) / 4) * 320 ;
  }
  
  [scrollView setContentSize:CGSizeMake(right_margin, 160)];

  year = 0 ;
  month = 0;
  stampItem = 0;
}

-(void) selectItem:(UIButton*)sender
{
  stampItem = sender.tag-30 + 1;
  [self setAgeImage];
}

-(void) setAgeImage
{
  demoView.image = nil;
  UIImage* result= [AgeUtil generateAgeStampImage:stampItem andYear:year andMonth:month];
//  UIImage* result = [UIImage imageWithCGImage:image.CGImage scale:image.scale*0.1 orientation:image.imageOrientation];
  demoView.image = result;

//  CGRect rect = demoView.frame;
//  rect.size = result.size;
//  rect.origin.x = (320 - result.size.width)/2;
//  demoView.frame = rect;
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
//  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"stamp_age" bundle:nil];
//  SetAgeViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"SetAgeViewController"];
//  controller.delegate = self;
//  [self.navigationController pushViewController:controller animated:YES];
  
  NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AgeDialog" owner:self options:nil];
  
  AgeDialog *dialog= [nib objectAtIndex:0];
  dialog.delegate = self;
  [self.view addSubview:dialog];
}

-(IBAction) arrowLeft:(id)sender
{
  [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(IBAction) arrowRight:(id)sender
{
  [scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
}

@end
