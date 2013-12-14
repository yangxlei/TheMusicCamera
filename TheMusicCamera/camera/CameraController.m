//
//  CameraController.m
//  TheMusicCamera
//
//  Created by yanglei on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "CameraController.h"
#import <ImageIO/ImageIO.h>

@interface CameraController ()
{
  AVCaptureSession *_session;
  AVCaptureDeviceInput *_captureInput;
  AVCaptureStillImageOutput *_captureOutput;
  AVCaptureVideoPreviewLayer *_preview;
  AVCaptureDevice *_device;
  
  UIImage *_finishImage;
}
@end

@implementation CameraController
@synthesize backBtn;
@synthesize flashBtn;
@synthesize kirikaeBtn;
@synthesize sizeBtn;
@synthesize cameraBtn;
@synthesize cameraView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.hidesBottomBarWhenPushed = YES;
  
  [self initialize];
  
  _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
  _preview.frame = CGRectMake(0, 0, self.cameraView.frame.size.width, self.cameraView.frame.size.height);
  _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
  
  [self.cameraView.layer addSublayer:_preview];
  [_session startRunning];
}

- (void) initialize
{
  //1.创建会话层
  _session = [[AVCaptureSession alloc] init];
  [_session setSessionPreset:AVCaptureSessionPreset640x480];
  
  //2.创建、配置输入设备
  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  [_device lockForConfiguration:nil];
  if([_device flashMode] == AVCaptureFlashModeOff){
    [flashBtn setImage:[UIImage imageNamed:@"shot_flash_off"] forState:UIControlStateNormal];
  }
  else if([_device flashMode] == AVCaptureFlashModeAuto){
    [flashBtn setImage:[UIImage imageNamed:@"shot_flash_off"] forState:UIControlStateNormal];
  }
  else{
    [flashBtn setImage:[UIImage imageNamed:@"shot_flash_on"] forState:UIControlStateNormal];
  }
  [_device unlockForConfiguration];
  
	NSError *error;
	_captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
	if (!_captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
  [_session addInput:_captureInput];
  
  
  //3.创建、配置输出
  _captureOutput = [[AVCaptureStillImageOutput alloc] init];
  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
  [_captureOutput setOutputSettings:outputSettings];
	[_session addOutput:_captureOutput];
}

-(IBAction) back:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) flash:(id)sender
{

}

-(IBAction) frontCamera:(id)sender
{

}

-(IBAction)sizeClick:(id)sender
{

}

-(IBAction)takePhoto:(id)sender
{
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
