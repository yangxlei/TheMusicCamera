//
//  StampView.h
//  TheMusicCamera
//
//  Created by song on 14-1-2.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;
@class DataManager;

@protocol StampViewDelegate

- (void)selectImageClick:(UIImage *)img andType:(int)type;

@end

@interface StampView : UIView<UIAlertViewDelegate>
{
    DataManager *dataManager;
}

@property (nonatomic, strong) id<StampViewDelegate> delegate;

- (void)initWithType:(int)type;

@end
