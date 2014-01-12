//
//  StampView.m
//  TheMusicCamera
//
//  Created by song on 14-1-2.
//  Copyright (c) 2014年 songl. All rights reserved.
//

#import "StampView.h"
#import "CustomButton.h"
#import "StoreKitHelper.h"
#import "DataManager.h"

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
    dataManager = [DataManager sharedManager];

    switch (type) {
        case 1:
        {
            UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            backImg.image = [UIImage imageNamed:@"decoration_stamp"];
            [self addSubview:backImg];
            
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
            scrollView.contentSize =CGSizeMake(320*(34/9 +1), self.frame.size.height-29);
            scrollView.pagingEnabled = YES;
            [self addSubview:scrollView];
            
            int vertical = 34/3 + 1;
            
            for (int i=0; i<vertical; i++) {
                for (int j=0; j<3; j++) {
                    if (i*3+j+1<34) {
                        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                        button.type = type;
                        button.frame = CGRectMake(35+95*i+(i/3*35), 10+80*j, 60, 60);
                        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stamp_%d",i*3+j+1]] forState:UIControlStateNormal];
                        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        button.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"stamp_%d",i*3+j+1]];
                        [button addTarget:self action:@selector(stampSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                        
                        if (i*3+j>=9 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"appStore"] intValue]==0) {
                            [button setUserInteractionEnabled:NO];
//                            UIImageView *interdictionImg = [[UIImageView alloc]initWithFrame:CGRectMake(35+95*i+(i/3*35), 10+80*j, 71, 45)];
//                            interdictionImg.image = [UIImage imageNamed:@"lock"];
//                            [scrollView addSubview:interdictionImg];
                            
                            UIButton *interdictionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            interdictionBtn.frame = CGRectMake(35+95*i+(i/3*35), 10+80*j, 71, 45);
                            [interdictionBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
                            //                            interdictionImg.image = [UIImage imageNamed:@"lock"];
                            [interdictionBtn addTarget:self action:@selector(interdictionBtn:) forControlEvents:UIControlEventTouchUpInside];
                            [scrollView addSubview:interdictionBtn];

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
            scrollView.contentSize =CGSizeMake(320*(13/9 +1), self.frame.size.height-29);
            scrollView.pagingEnabled = YES;
            [self addSubview:scrollView];
            
            int vertical = 13/3 + 1;
            
            for (int i=0; i<vertical; i++) {
                //        stamp_1
                for (int j=0; j<3; j++) {
                    if (i*3+j<13) {
                        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                        button.type = type;
                        button.frame = CGRectMake(35+95*i+(i/3*35), 10+80*j, 60, 60);
                        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%d_%d",i*3+j+1,[[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"] intValue]]] forState:UIControlStateNormal];
                        button.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%d_%d",i*3+j+1,[[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"] intValue]]];
                        [button addTarget:self action:@selector(stampSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                        
                        if (i*3+j>=9 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"appStore"] intValue]==0) {
                            [button setUserInteractionEnabled:NO];
                            
                            UIButton *interdictionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            interdictionBtn.frame = CGRectMake(35+95*i+(i/3*35), 10+80*j, 71, 45);
                            [interdictionBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
//                            interdictionImg.image = [UIImage imageNamed:@"lock"];
                            [interdictionBtn addTarget:self action:@selector(interdictionBtn:) forControlEvents:UIControlEventTouchUpInside];
                            [scrollView addSubview:interdictionBtn];
                            
                        }

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

- (void)interdictionBtn:(UIButton *)button
{
    dataManager.fromNo = 1;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"这是一个简单的警告框！"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"0");
        StoreKitHelper *store = [[StoreKitHelper alloc]init];
        [store buyItemWithType:0];
        
    }
    else
    {
        NSLog(@"1");
    }
}

@end
