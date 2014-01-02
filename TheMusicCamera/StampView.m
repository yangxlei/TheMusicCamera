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
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backImg.image = [UIImage imageNamed:@"decoration_stamp"];
    [self addSubview:backImg];

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
    scrollView.contentSize =CGSizeMake(320*2, self.frame.size.height-29);
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    
    int vertical = 14/3 + 1;
    
    for (int i=0; i<vertical; i++) {
//        stamp_1
        for (int j=0; j<3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(25+100*i, 10+80*j, 60, 60);
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"stamp_%d",i*3+j+1]] forState:UIControlStateNormal];
            [scrollView addSubview:button];
        }
        
    }
}

@end
