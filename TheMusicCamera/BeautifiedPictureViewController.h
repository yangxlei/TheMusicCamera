//
//  BeautifiedPictureViewController.h
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampView.h"
#import "TextFontViewController.h"
#import "ImagePickerController.h"
#import "StampAgeController.h"
#import "VPImageCropperViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@class DataManager;
//@class StampView;

@interface BeautifiedPictureViewController : UIViewController<UINavigationControllerDelegate, StampViewDelegate,TextFontVCDelegate, StampAgeControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>
{
    IBOutlet UIImageView* imageView;
    IBOutlet UIView *mianView;
    
    DataManager *dataManager;

    int selectBtnTag;
    StampView *stampView;
    StampView *stampFrameView;

    NSMutableArray *stampArr;
    NSMutableArray *stampFrameArr;

}

-(void) begin;
@end
