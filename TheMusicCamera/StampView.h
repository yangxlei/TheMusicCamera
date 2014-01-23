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
- (void)selectImageWating;

@end

@interface StampView : UIView<UIAlertViewDelegate,UIScrollViewDelegate>
{
    DataManager *dataManager;
    int currentPage;
    UIScrollView *scrollView;
    int totaolPage;
    
    UIButton *leftArrow;
    UIButton *rightArrow;
    int stampType;
    
}

@property (nonatomic, strong) id<StampViewDelegate> delegate;

- (void)initWithType:(int)type;

@end
