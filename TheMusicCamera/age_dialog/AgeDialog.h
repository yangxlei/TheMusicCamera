//
//  AgeDialog.h
//  TheMusicCamera
//
//  Created by yanglei on 14-1-21.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgeDialogDelegate <NSObject>

-(void) didFinishSetAge:(int) year andMonth:(int)month;
@end

@interface AgeDialog : UIView
{
  int year , month ;
}

@property(nonatomic, strong) IBOutlet UILabel* yearLabel;
@property (nonatomic, strong) IBOutlet UILabel* monthLabel;

@property (nonatomic, assign) id<AgeDialogDelegate> delegate ;

-(IBAction) yearPlus:(id)sender;
-(IBAction) monthPlus:(id)sender;

-(IBAction) yearMimus:(id)sender;
-(IBAction) monthMimus:(id)sender;

-(IBAction) okClick:(id)sender;
@end
