//
//  AgeUtil.m
//  TSLocateView
//
//  Created by yanglei on 14-1-12.
//  Copyright (c) 2014年 Telenav Software, Inc. All rights reserved.
//

#import "AgeUtil.h"

@implementation AgeUtil

+(UIImage*) generateAgeStampImage:(int)item andYear:(int)year andMonth:(int)month
{
  UIImage* stamp = [UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d.png", item]];
  UIImage* number = [UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d_number.png", item]];
  
  if (year < 0 || month < 0)
  {
    return  stamp;
  }
  
  UIImage* yearImg, *monthImg;
  CGRect rect1, rect2;
  

  
  switch (item) {
    case 1:
      yearImg = [self getNumber:year inImage:number withOffset:0];
      monthImg = [self getNumber:month inImage:number withOffset:0];
     rect1.origin.x = 110;
      rect1.origin.y = 148;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 110;
      rect2.origin.y = 212;
      rect2.size = monthImg.size;
      break;
    case 2:
      yearImg = [self getNumber:year inImage:number withOffset:0];
      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 26;
      rect1.origin.y = 13;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 202;
      rect2.origin.y = 13;
      rect2.size = monthImg.size;
      break;
    case 3:
      yearImg = [self getNumber:year inImage:number withOffset:0];
      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 26;
      rect1.origin.y = 27;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 26;
      rect2.origin.y = 110;
      rect2.size = monthImg.size;
      break;
    case 4:
      yearImg = [self getNumber:year inImage:number withOffset:15];
      monthImg = [self getNumber:month inImage:number withOffset:15];
      
      rect1.origin.x = 95;
      rect1.origin.y = 64;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 105;
      rect2.origin.y = 140;
      rect2.size = monthImg.size;
      break;
    case 5:
      yearImg = [self getNumber:year inImage:number withOffset:0];
      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 53;
      rect1.origin.y = 72;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 48;
      rect2.origin.y = 110;
      rect2.size = monthImg.size;
      break;
    case 6:
      yearImg = [self getNumber:year inImage:number withOffset:12];
      monthImg = [self getNumber:month inImage:number withOffset:12];
      
      rect1.origin.x = 202;
      rect1.origin.y = 53;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 205;
      rect2.origin.y = 85;
      rect2.size = monthImg.size;
      break;
    case 7:
      yearImg = [self getNumber:year inImage:number withOffset:3];
      monthImg = [self getNumber:month inImage:number withOffset:3];
      
      rect1.origin.x = 129;
      rect1.origin.y = 37;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 129;
      rect2.origin.y = 85;
      rect2.size = monthImg.size;
      break;
    case 8:
      yearImg = [self getNumber:year inImage:number withOffset:5];
      monthImg = [self getNumber:month inImage:number withOffset:5];
      
      rect1.origin.x = 150;
      rect1.origin.y = 17;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 152;
      rect2.origin.y = 72;
      rect2.size = monthImg.size;
      break;
      
    default:
      return nil;
  }
  return [self drawImage:yearImg andMonth:monthImg withYearRect:rect1 withMonthRect:rect2 inSource:stamp];
}

+(UIImage*) drawImage:(UIImage*) year andMonth:(UIImage*) month withYearRect:(CGRect) rect1 withMonthRect:(CGRect) rect2 inSource:(UIImage*) source
{
  CGSize size = source.size;
  
  CGRect srcrect = CGRectZero;
  srcrect.size = size;
  
  UIGraphicsBeginImageContext(size);
  
  [source drawInRect:srcrect];
  [year drawInRect:rect1];
  [month drawInRect:rect2];
  
  UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return resultingImage;
}

+(UIImage*) getNumber:(int) number inImage:(UIImage*) image withOffset: (int) offset
{
  CGRect rect;
  
  CGFloat width = image.size.width /10 ;
  
	rect.origin.x = number*width - offset;
	rect.origin.y = 0;
	rect.size.width =  width;
	rect.size.height = image.size.height;
	
	CGImageRef cr = CGImageCreateWithImageInRect(image.CGImage, rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
  
	
	CGImageRelease(cr);
  return cropped;
}

@end
