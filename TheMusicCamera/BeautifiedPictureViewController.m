//
//  BeautifiedPictureViewController.m
//  TheMusicCamera
//
//  Created by gzhy on 13-12-13.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "BeautifiedPictureViewController.h"
#import "WaterImageController.h"
#import "DataManager.h"
//#import "StampView.h"
#import "ZDStickerView.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface BeautifiedPictureViewController ()
{
  CropperController* cropper;
}
@end

@implementation BeautifiedPictureViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
    [UIApplication sharedApplication].statusBarHidden=YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    dataManager = [DataManager sharedManager];

    selectBtnTag = 1;
    
    [self navgationImage:@"header"];
    
    UIButton *editBtn = [self navgationButton:@"button_OK" andFrame:CGRectMake(260, 10, 52, 28)];
    [editBtn addTarget:self action:@selector(okBtuuon) forControlEvents:UIControlEventTouchUpInside];

    stampView = [[StampView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51-260, 320, 260)];
    stampView.hidden = YES;
    stampView.delegate = self;
    [stampView initWithType:1];
    [self.view addSubview:stampView];
    
    stampFrameView = [[StampView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51-260, 320, 260)];
    stampFrameView.hidden = YES;
    stampFrameView.delegate = self;
    [stampFrameView initWithType:2];
    [self.view addSubview:stampFrameView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelClick:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
}

-(IBAction) useClick:(id)sender
{
  
 
}
-(IBAction) changeSize:(id)sender
{

}

-(void) begin
{
  if (cropper == nil) {
    cropper = [[CropperController alloc] init];
    cropper.delegate = self;
  }
  [self presentViewController:cropper animated:NO completion:nil];
  [cropper begin];
}

-(void) onDidFinishCrop:(UIImage *)image
{
  imageView.image = image;
  dataManager.shareImg = image;
}

- (void)okBtuuon
{
    
    UIGraphicsBeginImageContext(mianView.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [mianView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    dataManager.shareImg = viewImage;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNSHAREVC" object:nil];
  
}

- (IBAction)toolsBtn:(id)sender {
    for (int i=1; i<5; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.selected = NO;
    }
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
  UIStoryboard* storyboard = nil;
    switch (btn.tag) {
        case 1:
        {
            stampFrameView.hidden = YES;
            if (stampView.hidden) {
                stampView.hidden = NO;
            }
            else
            {
                stampView.hidden = YES;
            }
            

        }
            break;
        case 2:
        {
            stampView.hidden = YES;
            if (stampFrameView.hidden) {
                stampFrameView.hidden = NO;
            }
            else
            {
                stampFrameView.hidden = YES;
            }

        }
            break;
        case 3:
        {
          storyboard = [UIStoryboard storyboardWithName:@"stamp_age" bundle:nil];
          [self.navigationController pushViewController:[storyboard instantiateInitialViewController] animated:YES];
        }
            break;
        case 4:
        {
            
        }
            break;
  
        default:
            break;
    }
}

- (void)selectImageClick:(UIImage *)img andType:(int)type
{
    if (type==1) {
        UIImageView *imageV = [[UIImageView alloc]
                               initWithImage:img];
        
        CGRect gripFrame1 = CGRectMake(50, 50, 140, 140);
        ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame1];
        userResizableView1.contentView = imageV;
        userResizableView1.preventsPositionOutsideSuperview = YES;
        [userResizableView1 showEditingHandles];
        [mianView addSubview:userResizableView1];
    }
    else if (type==2)
    {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
        image.image = img;
        [mianView addSubview:image];
        mianView.backgroundColor = [UIColor greenColor];
    }

    
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:gripFrame2];
//    textView.text = @"ZDStickerView is Objective-C module for iOS and offer complete configurability, including movement, resizing, rotation and more, with one finger.";
//    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
//    userResizableView2.contentView = textView;
//    userResizableView2.preventsPositionOutsideSuperview = NO;
//    [userResizableView2 showEditingHandles];
//    [self.view addSubview:userResizableView2];

}

@end
