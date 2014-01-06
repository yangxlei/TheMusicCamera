//
//  StampView.h
//  TheMusicCamera
//
//  Created by song on 14-1-2.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;

@protocol StampViewDelegate

- (void)selectImageClick:(UIImage *)img;

@end

@interface StampView : UIView

@property (nonatomic, strong) id<StampViewDelegate> delegate;

- (void)initWithType:(int)type;

@end
