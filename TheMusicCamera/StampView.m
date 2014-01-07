//
//  StampView.m
//  TheMusicCamera
//
//  Created by song on 14-1-2.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "StampView.h"
#import "CustomButton.h"

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
    switch (type) {
        case 1:
        {
            UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            backImg.image = [UIImage imageNamed:@"decoration_stamp"];
            [self addSubview:backImg];
            
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
            scrollView.contentSize =CGSizeMake(320*(14/9 +1), self.frame.size.height-29);
            scrollView.pagingEnabled = YES;
            [self addSubview:scrollView];
            
            int vertical = 14/3 + 1;
            
            for (int i=0; i<vertical; i++) {
                for (int j=0; j<3; j++) {
                    if (i*3+j+1<14) {
                        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                        button.type = type;
                        button.frame = CGRectMake(25+100*i, 10+80*j, 60, 60);
                        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stamp_%d",i*3+j+1]] forState:UIControlStateNormal];
                        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        button.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"stamp_%d",i*3+j+1]];
                        [button addTarget:self action:@selector(stampSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                        
                        if (i*3+j>=9) {
                            [button setUserInteractionEnabled:NO];
                            UIImageView *interdictionImg = [[UIImageView alloc]initWithFrame:CGRectMake(25+100*i, 10+80*j, 71, 45)];
                            interdictionImg.image = [UIImage imageNamed:@"lock"];
                            [scrollView addSubview:interdictionImg];
                        }

                    }
                }
            }

        }
            break;
        case 2:
        {
            UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            backImg.image = [UIImage imageNamed:@"decorathion_flame"];
            [self addSubview:backImg];
            
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
            scrollView.contentSize =CGSizeMake(320*1/9, self.frame.size.height-29);
            scrollView.pagingEnabled = YES;
            [self addSubview:scrollView];
            
            int vertical = 1/3 + 1;
            
            for (int i=0; i<vertical; i++) {
                //        stamp_1
                for (int j=0; j<3; j++) {
                    if (i*3+j<1) {
                        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                        button.type = type;
                        button.frame = CGRectMake(25+100*i, 10+80*j, 60, 60);
                        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"flame_1_1"]] forState:UIControlStateNormal];
                        button.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"flame_1_1"]];
                        [button addTarget:self action:@selector(stampSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                    }
                }
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)stampSelect:(CustomButton *)button 
{
    [self.delegate selectImageClick:button.btnImage andType:button.type];
}

@end
