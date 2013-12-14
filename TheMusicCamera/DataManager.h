//
//  DataManager.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTTabBarController.h"

@interface DataManager : NSObject
{
    
}

@property (nonatomic, strong) GTTabBarController *mainTabBarController;


+ (DataManager *) sharedManager;

@end

@interface UIViewController (UIViewControllerCategory)


- (void)navgationImage:(NSString *)imageName;
- (UIButton *)navgationButton:(NSString *)buttonImage andFrame:(CGRect)rect;


@end
