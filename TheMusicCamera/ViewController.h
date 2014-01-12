//
//  ViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTabBarController.h"
#import "BeautifiedPictureViewController.h"
@class DataManager;

@interface ViewController : UIViewController<UINavigationControllerDelegate, GTTabBarControllerDelegate>
{
    DataManager *dataManager;
    BOOL firstEntry;//第一次启动进入app
  
  BeautifiedPictureViewController* bpVC;
}
@property (nonatomic, strong) GTTabBarController *mainTabBarController;

+(UIViewController*) shareInstance;
@end
