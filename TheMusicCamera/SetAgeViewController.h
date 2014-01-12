//
//  StampAgeController.h
//  TheMusicCamera
//
//  Created by yanglei on 14-1-6.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol SetAgeViewControllerDelegate <NSObject>

-(void) didFinishSetAge:(int) year andMonth:(int)month;


@end

@interface SetAgeViewController: UIViewController<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UILabel* age;
//@property (nonatomic, strong) IBOutlet UIImageView* demoView;
@property (nonatomic, assign) id<SetAgeViewControllerDelegate> delegate;

-(IBAction) ageClick:(id)sender;
@end
