//
//  StampAgeController.m
//  TheMusicCamera
//
//  Created by yanglei on 14-1-6.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "SetAgeViewController.h"
#import "TSLocateView.h"
@interface SetAgeViewController()
{
  int year;
  int month;
}

@end

@implementation SetAgeViewController
@synthesize age;
@synthesize delegate;
//@synthesize demoView;

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
  
  UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
  [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *editBtn = [self navgationButton:@"button_OK.png" andFrame:CGRectMake(250, 10, 62, 31)];
  [editBtn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
  
  year = -1 ;
  month = -1;
  
 }

-(void) okBtn:(id) sender
{
  if (year >= 0 && month >= 0)
  {
    [delegate didFinishSetAge:year andMonth:month];
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

-(IBAction)ageClick:(id)sender
{
  TSLocateView* pickerView = [[TSLocateView alloc] initWithTitle:@"" delegate:self];
  [pickerView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 1)
  {
    TSLocateView* pickerView = (TSLocateView*)actionSheet;
    year = pickerView.year;
    month = pickerView.month;
    age.text = [NSString stringWithFormat:@"%d歳 %dか月",year,month];
  }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{

}


@end
