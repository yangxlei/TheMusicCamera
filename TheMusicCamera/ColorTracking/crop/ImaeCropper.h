//
//  ImaeCropper.h
//  CropImage
//
//  Created by yanglei on 14-1-8.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCropperDelegate <NSObject>

-(void) didCropImage:(UIImage*) image;
-(void) onCacnel;

@end

@interface ImaeCropper : UIViewController<UIScrollViewDelegate>
{
  BOOL sizeFlag;
    UIButton* onebtn;
    UIButton* fourbtn;
}

-(id) initWithImage:(UIImage*) image;

@property (nonatomic, assign) id<ImageCropperDelegate> delegate;

@end
