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
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *downloadPath;
@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *path;
@property (readwrite) BOOL isPhotoView;


+ (DataManager *) sharedManager;

@end

@interface UIViewController (UIViewControllerCategory)


- (void)navgationImage:(NSString *)imageName;
- (UIButton *)navgationButton:(NSString *)buttonImage andFrame:(CGRect)rect;


@end
