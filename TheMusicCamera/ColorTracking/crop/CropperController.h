//
//  CropperController.h
//  TheMusicCamera
//
//  Created by yanglei on 14-1-3.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICropImageView.h"

@protocol CropControllerDelegate <NSObject>

-(void) onDidFinishCrop:(UIImage*) image;

@end

@interface CropperController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
  BOOL resizeFlag;
  KICropImageView* cropImageView;
}

@property(nonatomic,assign) id<CropControllerDelegate> delegate;

-(void) begin;

@end

