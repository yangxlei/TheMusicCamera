//
//  BeautifiedPictureViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropperController.h"
@class DataManager;
@class StampView;

@interface BeautifiedPictureViewController : UIViewController<UINavigationControllerDelegate, CropControllerDelegate>
{
  IBOutlet UIImageView* imageView;
    IBOutlet UIView *mianView;
    
    DataManager *dataManager;

    int selectBtnTag;
    StampView *stampView;
}

-(void) begin;
@end
