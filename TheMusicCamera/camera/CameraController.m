//
//  CameraController.m
//  TheMusicCamera
//
//  Created by yanglei on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "CameraController.h"
#import <ImageIO/ImageIO.h>
#import "DataManager.h"
//#import <MediaPlayer/MediaPlayer.h>
//UIImagePickerController * picker=[[UIImagePickerController alloc]init];
//[picker takePicture];//他将会自动调用代理方法完成照片的拍摄；

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
    dataManager = [DataManager sharedManager];

  [self initialize];
  
  _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
  int height = MIN(427, self.cameraView.frame.size.height);
  _preview.frame = CGRectMake(0, (self.cameraView.frame.size.height - height)/2, 320, height);
  _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
  
  [self.cameraView.layer addSublayer:_preview];
  [_session startRunning];
    
    
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//    mpc.volume = 0;  //0.0~1.0
    ///////////////////磊磊上面是我加的

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
    [flashBtn setSelected:NO];
  }
  else if([_device flashMode] == AVCaptureFlashModeAuto){
    [flashBtn setSelected:NO];
  }
  else{
    [flashBtn setSelected:YES];
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
  if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && [_device hasFlash])
  {
    [flashBtn setEnabled:NO];
    [_session beginConfiguration];
    [_device lockForConfiguration:nil];
    if (flashBtn.isSelected) {
      [flashBtn setSelected:NO];
      [_device setFlashMode:AVCaptureFlashModeOff];
    }
    else
    {
      [flashBtn setSelected:YES];
      [_device setFlashMode:AVCaptureFlashModeOn];
    }
//    if([_device flashMode] == AVCaptureFlashModeOff)
//    {
//      [_device setFlashMode:AVCaptureFlashModeAuto];
//      [flashBtn setSelected:NO];
//    }
//    else if([_device flashMode] == AVCaptureFlashModeAuto)
//    {
//      [_device setFlashMode:AVCaptureFlashModeOn];
//      [flashBtn setSelected:YES];
//    }
//    else{
//      [_device setFlashMode:AVCaptureFlashModeOff];
//      [flashBtn setSelected:NO];
//    }
    [_device unlockForConfiguration];
    [_session commitConfiguration];
    [flashBtn setEnabled:YES];
  }
}

-(IBAction) frontCamera:(id)sender
{
  //添加动画
  CATransition *animation = [CATransition animation];
  animation.delegate = self;
  animation.duration = .8f;
  animation.timingFunction = UIViewAnimationCurveEaseInOut;
  animation.type = @"oglFlip";
  if (_device.position == AVCaptureDevicePositionFront) {
    animation.subtype = kCATransitionFromRight;
  }
  else if(_device.position == AVCaptureDevicePositionBack){
    animation.subtype = kCATransitionFromLeft;
  }
  [_preview addAnimation:animation forKey:@"animation"];
  
  NSArray *inputs = _session.inputs;
  for ( AVCaptureDeviceInput *input in inputs )
  {
    AVCaptureDevice *device = input.device;
    if ([device hasMediaType:AVMediaTypeVideo])
    {
      AVCaptureDevicePosition position = device.position;
      AVCaptureDevice *newCamera = nil;
      AVCaptureDeviceInput *newInput = nil;
      
      if (position == AVCaptureDevicePositionFront)
      {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
      }
      else
      {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
      }
      _device = newCamera;
      newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
      
      // beginConfiguration ensures that pending changes are not applied immediately
      [_session beginConfiguration];
      
      [_session removeInput:input];
      [_session addInput:newInput];
      
      // Changes take effect once the outermost commitConfiguration is invoked.
      [_session commitConfiguration];
      break;
    }
  }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  for (AVCaptureDevice *device in devices)
  {
    if (device.position == position)
    {
      return device;
    }
  }
  return nil;
}

-(IBAction)sizeClick:(id)sender
{
  int height ;
  if (sizeBtn.isSelected)
  {
    [sizeBtn setSelected:NO];
    height = 320;
  }
  else
  {
    [sizeBtn setSelected:YES];
    height = MIN(427, self.cameraView.frame.size.height);
  }
  
  _preview.frame = CGRectMake(0, (self.cameraView.frame.size.height - height) /2, 320, height);
  
}

-(IBAction)takePhoto:(id)sender
{
///////////////////
//    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] )
//    {
//        UIImagePickerController * picker=[[UIImagePickerController alloc]init];
//        [picker takePicture];//他将会自动调用代理方法完成照片的拍摄；
//    }
///////////////////磊磊上面是我加的
    
  [self addHollowCloseToView:self.cameraView];
  
  //get connection
  AVCaptureConnection *videoConnection = nil;
  for (AVCaptureConnection *connection in _captureOutput.connections) {
    for (AVCaptureInputPort *port in [connection inputPorts]) {
      if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
        videoConnection = connection;
        break;
      }
    }
    if (videoConnection) { break; }
  }
  
  //get UIImage
  [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
   ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
//     _saveButton.hidden = NO;
//     _cancelButton.hidden = NO;
     [self addHollowCloseToView:self.cameraView];
     [_session stopRunning];
     [self addHollowOpenToView:self.cameraView];
     CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
     if (exifAttachments) {
       // Do something with the attachments.
     }
     // Continue as appropriate.
     NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
     _finishImage = [[UIImage alloc] initWithData:imageData] ;
     [self.cameraView.layer removeAllAnimations];
     [cameraBtn setEnabled:NO];
   }];
}

- (void)addHollowOpenToView:(UIView *)view
{
  CATransition *animation = [CATransition animation];
  animation.duration = 0.5f;
  animation.delegate = self;
  animation.timingFunction = UIViewAnimationCurveEaseInOut;
  animation.fillMode = kCAFillModeForwards;
  animation.type = @"cameraIrisHollowOpen";
  [view.layer addAnimation:animation forKey:@"animation"];
}

- (void)addHollowCloseToView:(UIView *)view
{
  CATransition *animation = [CATransition animation];//初始化动画
  animation.duration = 0.5f;//间隔的时间
  animation.timingFunction = UIViewAnimationCurveEaseInOut;
  animation.type = @"cameraIrisHollowClose";
  
  [view.layer addAnimation:animation forKey:@"HollowClose"];
}

- (IBAction)playMusic:(id)sender
{
//    [[NSUserDefaults standardUserDefaults] objectForKey:@"musicID"]
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:music.ID] forKey:@"musicID"];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicOFF"] intValue]==1) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//静音下可以播放
        [[AVAudioSession sharedInstance] setActive: YES error:nil];
        
        NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
        int selectNO = [[[NSUserDefaults standardUserDefaults] objectForKey:@"musicID"] intValue];
        NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@", savePath,[dataManager selectMusicWithID:selectNO]];
        //    recordedFile = [NSURL fileURLWithPath:recorderFilePath];
        
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
        //初始化音频类 并且添加播放文件
        avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        avAudioPlayer.delegate = self;
        isPlay = YES;
        avAudioPlayer.delegate = self;
        avAudioPlayer.volume=1.0;//0.0~1.0之间
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicrepeat"] intValue]==1) {
            avAudioPlayer.numberOfLoops = -1;
        }
        else
        {
            avAudioPlayer.numberOfLoops = 0;
        }
        
        [avAudioPlayer play];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    
}

@end
