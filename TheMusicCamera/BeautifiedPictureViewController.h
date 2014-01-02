//
//  BeautifiedPictureViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"
@class DataManager;

@interface BeautifiedPictureViewController : UIViewController<UINavigationControllerDelegate,GKImagePickerDelegate>
{
  IBOutlet UIImageView* imageView;
    IBOutlet UIView *mianView;
    
    DataManager *dataManager;

    int selectBtnTag;
}

-(void) begin;
@end
