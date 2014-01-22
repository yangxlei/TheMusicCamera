//
//  ImagePickerController.h
//  CropImage
//
//  Created by yanglei on 14-1-8.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImaeCropper.h"

@protocol ImagePickerControllerDelegate <NSObject>

-(void) didFinishImagePickerAndCrop:(UIImage*) image;

-(void) didCacnel;

@end

@interface ImagePickerController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate,ImageCropperDelegate>
{
//  ImaeCropper * cropper ;
}


@property(nonatomic, assign) id<ImagePickerControllerDelegate> delegate;

-(void) begin;

@end
