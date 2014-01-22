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
  
    _musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicstation"] intValue]==1) {
        _musicBtn.frame = CGRectMake(20, self.view.frame.size.height-150, 44, 44);
    }
    else
    {
        _musicBtn.frame = CGRectMake(self.view.frame.size.width-64, self.view.frame.size.height-150, 44, 44);
    }
    [_musicBtn setBackgroundImage:[UIImage imageNamed:@"shoot_sound_button"] forState:UIControlStateNormal];
    [_musicBtn addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_musicBtn];
    
    
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"anime_1.png"],
                         [UIImage imageNamed:@"anime_2.png"],
                         [UIImage imageNamed:@"anime_3.png"],
                         [UIImage imageNamed:@"anime_4.png"], nil];
    
    UIImageView *myAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 320)];
    myAnimatedView.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    myAnimatedView.animationDuration = 1.0; //浏览整个图片一次所用的时间
    myAnimatedView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [myAnimatedView startAnimating]; 
    [self.view addSubview:myAnimatedView];

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
  
  if (!isFront)
  {
    _device = [self cameraWithPosition:AVCaptureDevicePositionBack];
  }
  else
  {
    _device = [self cameraWithPosition:AVCaptureDevicePositionFront];
  }
  
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
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    int height = MIN(427, self.cameraView.frame.size.height);
    _preview.frame = CGRectMake(0, (self.cameraView.frame.size.height - height)/2, 320, height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.cameraView.layer addSublayer:_preview];
    [_session startRunning];


}

- (void) initializeVideo
{
    cameraStop = NO;
    NSError *error = nil;
    
    // Create the session
    _session = [[AVCaptureSession alloc] init];
    
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.
    _session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Find a suitable AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
  
    // Create a device input with the device and add it to the session.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.
    }
    [_session addInput:input];
    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [_session addOutput:output];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                            [NSNumber numberWithInt: 320], (id)kCVPixelBufferWidthKey,
                            [NSNumber numberWithInt: 240], (id)kCVPixelBufferHeightKey,
                            nil];
    
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    int height = MIN(427, self.cameraView.frame.size.height);
    _preview.frame = CGRectMake(0, (self.cameraView.frame.size.height - height)/2, 320, height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.cameraView.layer addSublayer:_preview];
    [_session startRunning];
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
//    output.minFrameDuration = CMTimeMake(1, 15);
    device.ActiveVideoMinFrameDuration = CMTimeMake(1, 15);

    // Start the session running to start the flow of data
    [_session startRunning];

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
  isFront = !isFront;
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
    
    [avAudioPlayer stop];
    [_musicBtn setEnabled:NO];
    cameraStop = YES;
    
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
       UIImageWriteToSavedPhotosAlbum(_finishImage, nil, nil, nil);//然后将该图片保存到图片图
     [self.cameraView.layer removeAllAnimations];
     [cameraBtn setEnabled:NO];
     [self performSelector:@selector(resetCamear) withObject:nil afterDelay:0.8];
   }];
    
    
//    UIGraphicsBeginImageContext(self.cameraView.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
//    [self.cameraView.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
//    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图

}

- (void) resetCamear
{
  [cameraBtn setEnabled:YES];
  [_musicBtn setEnabled:YES];
  cameraStop = NO;
  
  [self initialize];
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
        
        
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];//控制音量小的问题？？？
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];

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

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    if (cameraStop) {
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
        
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


        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//然后将该图片保存到图片图
//
//        NSData *mData = UIImageJPEGRepresentation(image, 0.5);//这里的mData是NSData对象，后面的0.5代表生成的图片质量
        [_session stopRunning];
    }
    
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

@end
