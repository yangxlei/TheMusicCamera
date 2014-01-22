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
#import "MBProgressHUD.h"

#import "ViewController.h"
#import "Public.h"

#import "VPImageCropperViewController.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface BeautifiedPictureViewController ()
{
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

- (void)viewDidDisappear:(BOOL)animated
{
    
}

-(void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
//  self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
//        mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 300);
////        imageView.frame = CGRectMake(0, 0, 300, 300);
//    }
//    else
//    {
//        if (iPhone5) {
//            mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 400);
//            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
//        }
//        else
//        {
//            NSLog(@"---%f----%f----%f---%f",mianView.frame.origin.x,mianView.frame.origin.y,mianView.frame.size.width,mianView.frame.size.height);
//            mianView.frame = CGRectMake(25, 60, 270, 360);
//            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
//            
//        }
////        imageView.frame = CGRectMake(0, 0, 300, 400);
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNPHOTOVC" object:nil];
    [UIApplication sharedApplication].statusBarHidden=YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
        mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 300);
//        imageView.frame = CGRectMake(0, 0, 300, 300);
    }
    else
    {
        if (iPhone5) {
            mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 400);
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
        }
        else
        {
            NSLog(@"---%f----%f----%f---%f",mianView.frame.origin.x,mianView.frame.origin.y,mianView.frame.size.width,mianView.frame.size.height);
            mianView.frame = CGRectMake(25, 60, 270, 360);
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, mianView.frame.size.width, mianView.frame.size.height)];
        }
//        imageView.frame = CGRectMake(0, 0, 300, 400);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    dataManager = [DataManager sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fromReturnVC:) name:@"FROMRETURNVC" object:nil];

    stampArr = [[NSMutableArray alloc]initWithCapacity:0];
    stampFrameArr = [[NSMutableArray alloc]initWithCapacity:0];

    selectBtnTag = 1;
    
    [self navgationImage:@"header"];
    
    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];

    UIButton *editBtn = [self navgationButton:@"button_OK" andFrame:CGRectMake(250, 10, 62, 31)];
    [editBtn addTarget:self action:@selector(okBtuuon) forControlEvents:UIControlEventTouchUpInside];

    stampView = [[StampView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51-269, 320, 269)];
    stampView.hidden = YES;
    stampView.delegate = self;
    [stampView initWithType:1];
    [self.view addSubview:stampView];
    
    stampFrameView = [[StampView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51-269, 320, 269)];
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
    for (UIView *subview in mianView.subviews) {
        [subview removeFromSuperview];
	}

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
  UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  imagePicker.allowsEditing = NO;
  [self presentModalViewController:imagePicker animated:YES];
}

-(void) didFinishImagePickerAndCrop:(UIImage *)image
{

  /*
  [cropper dismissViewControllerAnimated:YES completion:^{
    if (imageView!=nil) {
    [imageView removeFromSuperview];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
    mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 300);
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
    [mianView addSubview:imageView];
    }
    else
    {
        if (iPhone5) {
            mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 400);
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
        }
        else
        {
//            mianView.frame = CGRectMake(25, 60, 270, 360);
            mianView.frame = CGRectMake(mianView.frame.origin.x, 60, 270, 360);

            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, mianView.frame.size.width, mianView.frame.size.height)];

        }
    [mianView addSubview:imageView];
    }
    
   imageView.image = image;
    dataManager.shareImg = image;
    
  }];
   */
}

-(void) didCacnel
{
  
  [self backBtuuon];
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

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"shareImage"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"RETURNSHAREVC" object:nil];
  	for (UIView *subview in mianView.subviews) {
        [subview removeFromSuperview];
	}

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
                btn.selected = NO;
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
                btn.selected = NO;
            }
        }
            break;
        case 3:
        {
            stampView.hidden = YES;
            stampFrameView.hidden = YES;

            btn.selected = NO;
          storyboard = [UIStoryboard storyboardWithName:@"stamp_age" bundle:nil];
          StampAgeController* controller = [storyboard instantiateInitialViewController];
          controller.delegate = self;
          [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:
        {
            stampView.hidden = YES;
            stampFrameView.hidden = YES;

            btn.selected = NO;
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
    stampView.hidden = YES;
    stampFrameView.hidden = YES;
    for (int i=1; i<5; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.selected = NO;
    }

    if (type==1) {
        UIImageView *imageV = [[UIImageView alloc]
                               initWithImage:img];
        
        CGRect gripFrame1 = CGRectMake(50, 50, img.size.width, img.size.height);
        ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:gripFrame1];
        userResizableView1.contentView = imageV;
        userResizableView1.preventsPositionOutsideSuperview = NO;
        [userResizableView1 showEditingHandles];
        [mianView addSubview:userResizableView1];
        
        [stampArr addObject:userResizableView1];
        
    }
    else if (type==2)
    {
        
        if (stampFrameArr.count!=0) {
            for (UIImageView *mView in stampFrameArr) {
                [mView removeFromSuperview];
            }
            [[stampFrameArr objectAtIndex:0]removeFromSuperview];
        }
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
        image.image = img;
        [mianView addSubview:image];
        [mianView insertSubview:image atIndex:1];
        [stampFrameArr addObject:image];
    }

}

- (void)selectImageWating
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbp.labelText = @"   购买中,请稍后...   ";

}

- (void)selectTextView:(UITextView *)textView
{
    
    CGRect gripFrame2 = CGRectMake(50, 50, 140, 140);
    UITextView *tv = [[UITextView alloc] initWithFrame:gripFrame2];
    tv.textColor = textView.textColor;
    tv.font = textView.font;
    tv.text = textView.text;
    
    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
    userResizableView2.contentView = tv;
    userResizableView2.preventsPositionOutsideSuperview = NO;
    [userResizableView2 showEditingHandles];
    [mianView addSubview:userResizableView2];

    [stampArr addObject:userResizableView2];

}

- (void) fromReturnVC: (NSNotification*) aNotification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    for (int i=1; i<5; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.selected = NO;
    }

    [stampView removeFromSuperview];
    [stampFrameView removeFromSuperview];
    
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

-(void) finishSetAge:(UIImage *)image
{
    UIImageView *imageV = [[UIImageView alloc]
                           initWithImage:image];
    
    CGRect gripFrame1 = CGRectMake(100, 50, 140, 140);
    ZDStickerView *ageView = [[ZDStickerView alloc] initWithFrame:gripFrame1];
    ageView.contentView = imageV;
    ageView.preventsPositionOutsideSuperview = NO;
    [ageView showEditingHandles];
    [mianView addSubview:ageView];
    [stampArr addObject:ageView];

}


#pragma picker image 
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [UIApplication sharedApplication].statusBarHidden=YES;
  
  UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
  [picker dismissModalViewControllerAnimated:YES];
  
  [self pushToCropImage: image];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
  
  [picker dismissModalViewControllerAnimated:YES];
  
  [self pushToCropImage:image];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated:NO];
  [self backBtuuon];
}

-(void) pushToCropImage:(UIImage*) image {
  UIImage* portraitImg = [self imageByScalingToMaxSize:image];
  // 裁剪
  VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
  imgEditorVC.delegate = self;
  
  [self.navigationController pushViewController:imgEditorVC animated:YES];
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
  if (imageView!=nil) {
//    [imageView removeFromSuperview];
    cleanRemoveFromSuperview(imageView);
  }
  if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageSize"]intValue]==1) {
    mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 300);
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
    [mianView addSubview:imageView];
  }
  else
  {
    if (iPhone5) {
      mianView.frame = CGRectMake(mianView.frame.origin.x, mianView.frame.origin.y, 300, 400);
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
    }
    else
    {
      mianView.frame = CGRectMake(25, 60, 270, 360);
      imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mianView.frame.size.width, mianView.frame.size.height)];
      
    }
    [mianView addSubview:imageView];
  }
  
  imageView.image = editedImage;
  dataManager.shareImg = editedImage;
  
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
  [self backBtuuon];
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
  if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
  CGFloat btWidth = 0.0f;
  CGFloat btHeight = 0.0f;
  if (sourceImage.size.width > sourceImage.size.height) {
    btHeight = ORIGINAL_MAX_WIDTH;
    btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
  } else {
    btWidth = ORIGINAL_MAX_WIDTH;
    btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
  }
  CGSize targetSize = CGSizeMake(btWidth, btHeight);
  return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
  UIImage *newImage = nil;
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
  if (CGSizeEqualToSize(imageSize, targetSize) == NO)
  {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if (widthFactor > heightFactor)
      scaleFactor = widthFactor; // scale to fit height
    else
      scaleFactor = heightFactor; // scale to fit width
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    // center the image
    if (widthFactor > heightFactor)
    {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    }
    else
      if (widthFactor < heightFactor)
      {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
      }
  }
  UIGraphicsBeginImageContext(targetSize); // this will crop
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width  = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [sourceImage drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  if(newImage == nil) NSLog(@"could not scale image");
  
  //pop the context to get back to the default
  UIGraphicsEndImageContext();
  return newImage;
}

void cleanRemoveFromSuperview( UIView * view ) {
  if(!view || !view.superview) return;
  
  //First remove any constraints on the superview
  NSMutableArray * constraints_to_remove = [NSMutableArray new];
  UIView * superview = view.superview;
  
  for( NSLayoutConstraint * constraint in superview.constraints) {
    if( constraint.firstItem == view ||constraint.secondItem == view ) {
      [constraints_to_remove addObject:constraint];
    }
  }
  [superview removeConstraints:constraints_to_remove];
  
  //Then remove the view itself.
  [view removeFromSuperview];
}

@end
