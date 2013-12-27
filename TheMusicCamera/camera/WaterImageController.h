//
//  WaterImageController.h
//  TheMusicCamera
//
//  Created by yanglei on 13-12-26.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterImageController : UIViewController
{
  UIImage* sourceImg;
}

@property(nonatomic, strong) IBOutlet UIImageView* imageview;


-(void) setSourceImage:(UIImage*) img;

@end
