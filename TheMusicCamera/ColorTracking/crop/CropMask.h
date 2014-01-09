//
//  CropMask.h
//  CropImage
//
//  Created by yanglei on 14-1-9.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropMask : UIView
{
  CGRect _cropRect;
}

-(void) setCropSize:(CGSize) size;

-(CGRect) cropRect;
@end
