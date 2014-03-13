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
    NSLog(@"%d---%d---%d",item,year,month);
//  UIImage* number = [UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d_number.png", item]];
  
  if (year < 0 || month < 0)
  {
    return  stamp;
  }
  
  UIImage* yearImg, *monthImg;
  CGRect rect1, rect2;
  
  yearImg = [self getNumberWith:year andItem:item];
  monthImg = [self getNumberWith:month andItem:item];

  
  switch (item) {
    case 1:
     rect1.origin.x = 153 -yearImg.size.width;
      rect1.origin.y = 148;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 150-monthImg.size.width;
      rect2.origin.y = 212;
      rect2.size = monthImg.size;
      break;
    case 2:
//      yearImg = [self getNumber:year inImage:number withOffset:0];
//      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 57 - yearImg.size.width;
      rect1.origin.y = 13;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 232 - monthImg.size.width;
      rect2.origin.y = 13;
      rect2.size = monthImg.size;
      break;
    case 3:
//      yearImg = [self getNumber:year inImage:number withOffset:0];
//      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 26;
      rect1.origin.y = 27;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 26;
      rect2.origin.y = 110;
      rect2.size = monthImg.size;
      break;
    case 4:
//      yearImg = [self getNumber:year inImage:number withOffset:15];
//      monthImg = [self getNumber:month inImage:number withOffset:15];
      
      rect1.origin.x = 154 - yearImg.size.width;
      rect1.origin.y = 64;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 157 - monthImg.size.width;
      rect2.origin.y = 140;
      rect2.size = monthImg.size;
      break;
    case 5:
//      yearImg = [self getNumber:year inImage:number withOffset:0];
//      monthImg = [self getNumber:month inImage:number withOffset:0];
      
      rect1.origin.x = 74 - yearImg.size.width;
      rect1.origin.y = 72;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 70 - monthImg.size.width;
      rect2.origin.y = 110;
      rect2.size = monthImg.size;
      break;
    case 6:
//      yearImg = [self getNumber:year inImage:number withOffset:12];
//      monthImg = [self getNumber:month inImage:number withOffset:12];
      
      rect1.origin.x = 232 - yearImg.size.width;
      rect1.origin.y = 53;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 235 - monthImg.size.width;
      rect2.origin.y = 85;
      rect2.size = monthImg.size;
      break;
    case 7:
//      yearImg = [self getNumber:year inImage:number withOffset:3];
//      monthImg = [self getNumber:month inImage:number withOffset:3];
      
      rect1.origin.x = 168 - yearImg.size.width;
      rect1.origin.y = 37;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 172 - monthImg.size.width;
      rect2.origin.y = 85;
      rect2.size = monthImg.size;
      break;
    case 8:
//      yearImg = [self getNumber:year inImage:number withOffset:5];
//      monthImg = [self getNumber:month inImage:number withOffset:5];
      
      rect1.origin.x = 171 - yearImg.size.width;
      rect1.origin.y = 17;
      rect1.size = yearImg.size;
      
      rect2.origin.x = 179 - monthImg.size.width;
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
  
  CGFloat width = image.size.width /11;
  
	rect.origin.x = number*width - offset;
	rect.origin.y = 0;
	rect.size.width =  width;
	rect.size.height = image.size.height;
	
	CGImageRef cr = CGImageCreateWithImageInRect(image.CGImage, rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
  
	
	CGImageRelease(cr);
  return cropped;
}

+(UIImage*) getNumberWith:(int) number andItem:(int) item {
  CGRect rect ;
  NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ages" ofType:@"plist"]];
  
  NSArray* age = [plist valueForKey:[NSString stringWithFormat:@"age_%d",item]];
  
  NSDictionary* info = [age objectAtIndex:number];
  
  int start = [[info valueForKey:@"start"] intValue];
  int end = [[info valueForKey:@"end"] intValue];
  
  UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"age_stamp_%d_number.png", item]];
  
  rect.origin.x = start;
  rect.origin.y = 0 ;
  rect.size.width = end - start;
  rect.size.height = img.size.height;
  
 	CGImageRef cr = CGImageCreateWithImageInRect(img.CGImage, rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
  
	
	CGImageRelease(cr);
  return cropped;
}

@end
