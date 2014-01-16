//
//  StampAgeController.h
//  TheMusicCamera
//
//  Created by yanglei on 14-1-6.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "SetAgeViewController.h"
#import "MQEditField.h"

@protocol StampAgeControllerDelegate <NSObject>

-(void) finishSetAge:(UIImage*) image;

@end

@interface StampAgeController : UIViewController<SetAgeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet MQEditField* age;
@property (nonatomic, strong) IBOutlet UIImageView* demoView;
@property (nonatomic, assign) id<StampAgeControllerDelegate> delegate;

-(IBAction) ageClick:(id)sender;

-(IBAction) arrowLeft:(id)sender;
-(IBAction) arrowRight:(id)sender;
@end
