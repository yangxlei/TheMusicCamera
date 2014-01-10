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
#import "ZDStickerView.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface BeautifiedPictureViewController ()
{
  ImagePickerController* cropper;
  UINavigationController* cropperNavi;
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
    
    stampArr = [[NSMutableArray alloc]initWithCapacity:0];
    stampFrameArr = [[NSMutableArray alloc]initWithCapacity:0];

    selectBtnTag = 1;
    
    [self navgationImage:@"header"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];

    UIButton *editBtn = [self navgationButton:@"button_OK" andFrame:CGRectMake(260, 10, 57, 31)];
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

- (void)backBtuuon
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
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
  if (cropperNavi == nil) {
    cropper  = [[ImagePickerController alloc] init];
    cropper.delegate = self;
    cropperNavi = [[UINavigationController alloc] initWithRootViewController:cropper];
  }
  [self presentViewController:cropperNavi animated:NO completion:nil];
  [cropper begin];
//  imageView.image = nil;
}

-(void) didFinishImagePickerAndCrop:(UIImage *)image
{       
  imageView.image = image;
  CGRect rect = imageView.frame;
  rect.size = image.size;
  imageView.frame =rect;
  dataManager.shareImg = image;
  [cropperNavi dismissViewControllerAnimated:YES completion:nil];
}

-(void) didCacnel
{
  [cropperNavi dismissViewControllerAnimated:NO completion:nil];
//  [self backBtuuon];
  [cropperNavi removeFromParentViewController];
  cropper = nil;
  cropperNavi = nil;
}

- (void)okBtuuon
{
    for (int i=0; i<stampArr.count; i++) {
        ZDStickerView *zdsView = [stampArr objectAtIndex:i];
        [zdsView hideEditingHandles];
    }
    
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
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TextFontViewController *textVC = [storyboard instantiateViewControllerWithIdentifier:@"TextFontViewController"];
            textVC.delegate = self;
            [self.navigationController pushViewController:textVC animated:YES];
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
        
        [stampArr addObject:userResizableView1];
        
    }
    else if (type==2)
    {
        if (stampFrameArr.count!=0) {
            [[stampFrameArr objectAtIndex:0]removeFromSuperview];
        }
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
        image.image = img;
        [mianView addSubview:image];
        [mianView insertSubview:image atIndex:1];
        
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

//- (void)selectColor:(UIColor *)color andFont:(UIFont *)fontStr
//{
//    CGRect gripFrame2 = CGRectMake(50, 200, 180, 140);
//    UITextView *textView = [[UITextView alloc] initWithFrame:gripFrame2];
//    textView.text = @"ZDStickerView is Objective-C module for iOS and offer complete configurability, including movement, resizing, rotation and more, with one finger.";
//    textView.textColor = color;
//    textView.font = fontStr;
//    
//    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
//    userResizableView2.contentView = textView;
//    userResizableView2.preventsPositionOutsideSuperview = NO;
//    [userResizableView2 showEditingHandles];
//    [mianView addSubview:userResizableView2];
//
//}

- (void)selectTextView:(UITextView *)textView
{
    CGRect gripFrame2 = CGRectMake(50, 50, 140, 140);
    UITextView *tv = [[UITextView alloc] initWithFrame:gripFrame2];
    tv.textColor = textView.textColor;
    tv.font = textView.font;
    tv.text = textView.text;
    
    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
    userResizableView2.contentView = tv;
    userResizableView2.preventsPositionOutsideSuperview = YES;
    [userResizableView2 showEditingHandles];
    [mianView addSubview:userResizableView2];

    [stampArr addObject:userResizableView2];

}

@end
