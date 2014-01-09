//
//  CropMask.m
//  CropImage
//
//  Created by yanglei on 14-1-9.
//  Copyright (c) 2014年 yanglei. All rights reserved.
//

#import "CropMask.h"

@implementation CropMask

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      self.backgroundColor = [UIColor clearColor];
      self.userInteractionEnabled = NO;
    }
    return self;
}

-(void) setCropSize:(CGSize)size
{
  _cropRect = CGRectZero;
  _cropRect.size = size;
  _cropRect.origin.x = (self.frame.size.width - size.width)/2;
  _cropRect.origin.y = (self.frame.size.height - size.height) /2 ;
  
  [self setNeedsDisplay];

}

-(CGRect) cropRect
{
  return _cropRect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  [super drawRect:rect];
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
  CGContextFillRect(ctx, self.bounds);
  
  CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
  CGContextStrokeRectWithWidth(ctx, _cropRect, 2.0f);
  
  CGContextClearRect(ctx, _cropRect);
}

@end
