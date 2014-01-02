//
//  StampView.m
//  TheMusicCamera
//
//  Created by song on 14-1-2.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "StampView.h"

@implementation StampView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initWithType:(int)type
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    [self addSubview:scrollView];
    
    
    for (int i=1; i<14; i++) {
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame
    }
}

@end
