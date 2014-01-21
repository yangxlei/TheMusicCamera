//
//  AgeDialog.m
//  TheMusicCamera
//
//  Created by yanglei on 14-1-21.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "AgeDialog.h"

@implementation AgeDialog

@synthesize yearLabel;
@synthesize monthLabel;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
  month = 0 ;
  year = 0;
  yearLabel.text = [NSString stringWithFormat:@"%d", year];
  monthLabel.text = [NSString stringWithFormat:@"%d", month];
}

-(IBAction) yearPlus:(id)sender
{
  if (year == 10) return;
  year ++ ;
  yearLabel.text = [NSString stringWithFormat:@"%d", year];
}

-(IBAction) yearMimus:(id)sender
{
  if (year == 0) return;
  year -- ;
  yearLabel.text = [NSString stringWithFormat:@"%d", year];
  
}

-(IBAction) monthPlus:(id)sender
{
  if (month == 11) return;
  month ++ ;
  monthLabel.text = [NSString stringWithFormat:@"%d", month];
}

-(IBAction) monthMimus:(id)sender
{
  if (month == 0) return;
  month -- ;
  monthLabel.text = [NSString stringWithFormat:@"%d", month];
}

-(IBAction)okClick:(id)sender
{
  [delegate didFinishSetAge:year andMonth:month];
  [self removeFromSuperview];
}

@end
