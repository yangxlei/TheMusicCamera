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
#import "UIButton+EnlargeArea.h"

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

    stampType = type;
    
    switch (type) {
        case 1:
        {
            UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            backImg.image = [UIImage imageNamed:@"decoration_stamp"];
            [self addSubview:backImg];
            
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
            scrollView.contentSize =CGSizeMake(320*(35/9 +1), self.frame.size.height-29);
            scrollView.delegate = self;
            scrollView.pagingEnabled = YES;
            [self addSubview:scrollView];
            
            int vertical = 35/3 + 1;
            
            totaolPage = (35/9 +1);
            
            for (int i=0; i<vertical; i++) {
                for (int j=0; j<3; j++) {
                    if (i*3+j+1<35) {
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
            
            scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 29, 320, self.frame.size.height-29)];
            scrollView.contentSize =CGSizeMake(320*(17/6 +1), self.frame.size.height-29);
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            [self addSubview:scrollView];
            
            int vertical = 19/2 + 1;
            totaolPage = (17/6 +1);

            for (int i=0; i<vertical; i++) {
                //        stamp_1
                for (int j=0; j<2; j++) {
                    if (i*2+j<18) {
                        CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
                        button.type = type;
                        button.frame = CGRectMake(35+95*i+(i/3*35), 40+100*j, 60, 60);
                        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%d_%d",i*2+j+1,[[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"] intValue]]] forState:UIControlStateNormal];
                        button.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%d_%d",i*2+j+1,[[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"] intValue]]];
                        NSLog(@"======%@",[NSString stringWithFormat:@"frame_%d_%d",i*2+j+1,[[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"] intValue]]);
                        [button addTarget:self action:@selector(stampSelect:) forControlEvents:UIControlEventTouchUpInside];
                        [scrollView addSubview:button];
                        
                        if (i*2+j>=6 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"appStore"] intValue]==0) {
                            [button setUserInteractionEnabled:NO];
                            
                            UIButton *interdictionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            interdictionBtn.frame = CGRectMake(35+95*i+(i/3*35), 50+100*j, 71, 45);
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
    leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    leftArrow.frame = CGRectMake(10, 130, 20, 21);
    [leftArrow setBackgroundImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [leftArrow setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [leftArrow addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftArrow];
    
    rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    rightArrow.frame = CGRectMake(290, 130, 20, 21);
    [rightArrow setBackgroundImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    [rightArrow setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [rightArrow addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightArrow];

    currentPage = 0;
    [self showArrow];

}

- (void)leftBtn:(UIButton *)button
{
    if (currentPage>=1) {
        currentPage--;
        //        [scrollView setContentOffset:CGPointMake(320*currentPage, 0)];
        [scrollView scrollRectToVisible:CGRectMake(320*currentPage,0,320,self.frame.size.height-29) animated:YES];
        
    }
}

- (void)rightBtn:(UIButton *)button
{
    if (currentPage<=totaolPage) {
        currentPage++;
        [scrollView scrollRectToVisible:CGRectMake(320*currentPage,0,320,self.frame.size.height-29) animated:YES];
    }
}

- (void)stampSelect:(CustomButton *)button 
{
    [self.delegate selectImageClick:button.btnImage andType:button.type];
}

- (void)interdictionBtn:(UIButton *)button
{
    dataManager.fromNo = 1;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ママカメラProアップグレード"
                                                       message:@"■録音件数が10件まで可能\n■全スタンプ使用可能\n■全フレーム使用可能\n■全年齢スタンプ使用可能\n■広告バナー削除"
                                                      delegate:self
                                             cancelButtonTitle:@"YES"
                                             otherButtonTitles:@"NO", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"0");
        [self.delegate selectImageWating];
        [[StoreKitHelper shareInstance] getAppstoreLocal];
        
    }
    else
    {
        NSLog(@"1");
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"currentPage  %d",currentPage);
    
    [self showArrow];
}

- (void)showArrow
{
    if (stampType==1) {
        if (currentPage==0) {
            rightArrow.hidden = NO;
            leftArrow.hidden = YES;
        }
        else if(currentPage==3)
        {
            rightArrow.hidden = YES;
            leftArrow.hidden = NO;
        }
        else
        {
            rightArrow.hidden = NO;
            leftArrow.hidden = NO;
        }
    }
    else if (stampType==2)
    {
        if (currentPage==0) {
            rightArrow.hidden = NO;
            leftArrow.hidden = YES;
        }
        else if(currentPage==2)
        {
            rightArrow.hidden = YES;
            leftArrow.hidden = NO;
        }
        else
        {
            rightArrow.hidden = NO;
            leftArrow.hidden = NO;
        }
    }
}

@end
