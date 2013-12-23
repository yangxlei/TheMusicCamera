//
//  CropImageController.m
//  TheMusicCamera
//
//  Created by yanglei on 13-12-21.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "CropImageController.h"
#import "MQRoundPatView.h"
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#import <CoreImage/CoreImage.h>
#import <math.h>
#import "objc/message.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface CropImageController ()

@end

@implementation CropImageController
@synthesize cropImageView;
@synthesize leftBT;
@synthesize rightBT;
@synthesize seletType;
@synthesize frameTexture;
@synthesize videoFrameSize;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) beginEdit:(SelectType)type
{
  self.seletType = type;
 if (type == SelectRectangl) { // 4:3
    
    MQCropPatView* cropPatView = [[MQRectCropPatView alloc] initWithFrame:CGRectMake(0, 0, cropImageView.frame.size.width, cropImageView.frame.size.height)];
   
      cropPatView.cropRect = CGRectMake(0, 51, 320, 320);
   
    cropPatView.fixOutSize = CGSizeZero;
    cropImageView.cropPatView = cropPatView;
    cropImageView.hidden = NO;
    [cropImageView setCropSizeInScreen:cropPatView.cropRect];
//    [self.view bringSubviewToFront:cropImageView];
//    [cropPatView release];
   
    [cropImageView setCropImageSource:[self saveImageFromGLView]];
    
    
  } else { // 1 : 1
    
    MQCropPatView* cropPatView = [[MQRoundPatView alloc] initWithFrame:CGRectMake(0, 0, cropImageView.frame.size.width, cropImageView.frame.size.height)];
      cropPatView.cropRect = CGRectMake(5, 103, 320, 320);

    cropPatView.fixOutSize = CGSizeZero;
    cropImageView.cropPatView = cropPatView;
    cropImageView.hidden = NO;
    [cropImageView setCropSizeInScreen:cropPatView.cropRect];
//    [self.view bringSubviewToFront:cropImageView];
//    [cropPatView release];
    [cropImageView setCropImageSource:[self saveImageFromGLView]];
  }
}

- (UIImage *)saveImageFromGLView
{
  [[ProcessGLView sharedProcessGLView] beginTextureCapture:self.videoFrameSize];
  
  //    static const GLfloat squareVertices_home_left[] = {
  //        1.0f,  -1.0f,
  //        1.0f,  1.0f,
  //        -1.0f, -1.0f,
  //        -1.0f, 1.0f,
  //    };
  //    static const GLfloat squareVertices_home_right[] = {
  //        -1.0f, 1.0f,
  //        -1.0f, -1.0f,
  //        1.0f,  1.0f,
  //        1.0f,  -1.0f,
  //    };
  
  static const GLfloat squareVertices_portrait[] = {
    -1.0f, -1.0f,
    1.0f, -1.0f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
  };
  
  //    const CGFloat* squareVertices = nil;
  //    if (image_orientation == UIDeviceOrientationLandscapeLeft)
  //    {
  //        squareVertices = squareVertices_home_left;
  //    }
  //    else if (image_orientation == UIDeviceOrientationLandscapeRight)
  //    {
  //        squareVertices = squareVertices_home_right;
  //    }
  //    else
  //    {
  //        squareVertices = squareVertices_portrait;
  //    }
  
  [ProcessGLView sharedProcessGLView].image_orientation = UIDeviceOrientationPortrait;
  [[ProcessGLView sharedProcessGLView] drawGL:squareVertices_portrait frameTexture:frameTexture];
  
  return [[ProcessGLView sharedProcessGLView] endTextureCapture];
}


-(IBAction)cancelClick:(id)sender
{
  [[ProcessGLView sharedProcessGLView] clearScreenAndDraw];
  [delegate cancelProcessPhoto];
}

-(IBAction) useClick:(id)sender
{
  
//  UIActivityIndicatorView* actprocess = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//  actprocess.center = self.view.center;
//  
//  [self.view addSubview:actprocess];
//  
//  [actprocess startAnimating];
  //afteruse
//  [self performSelector:@selector(afteruse:) withObject:actprocess afterDelay:0];
    [self performSelector:@selector(afteruse:) withObject:nil afterDelay:0];

 }

-(void)afteruse:(UIActivityIndicatorView*)active
{
  UIImage *image = [cropImageView sourceImage];
  
  // save image
  //  if (saveToAlbum) {
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
  });
  //  }
  NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:2];
  NSMutableDictionary* params = [NSMutableDictionary dictionary];
  [params setValue:image forKey:@"sourceImage"];
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
  [dic setValue:imagesArray forKey:@"images"];
  [dic setValue:params forKey:@"params"];
  //  if (self.seletType != SelectNone) {
  CGRect rc = CGRectZero;
  UIImage* resultImg = [[UIImage alloc] init];
  [cropImageView getCropResult:&rc crppedImage:&resultImg type:self.seletType];
  //    [params setRect:rc forKey:@"rect"];
  [params setObject:[NSValue valueWithCGRect:rc] forKey:@"rect"];
  [imagesArray addObject:resultImg];
  //  } else {
  //    [imagesArray addObject:image];
  //  }
  
  [delegate useProcessPhoto:dic];
  
  
  [[ProcessGLView sharedProcessGLView] setDisplayFramebuffer];
  [[ProcessGLView sharedProcessGLView] clearScreenAndDraw];
//  [active stopAnimating];
//  [active removeFromSuperview];
}


- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
  
  CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:NO], kCVPixelBufferCGImageCompatibilityKey,
                           [NSNumber numberWithBool:NO], kCVPixelBufferCGBitmapContextCompatibilityKey,
                           nil];
  CVPixelBufferRef pxbuffer = NULL;
  CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                        frameSize.height,  kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef) options,
                                        &pxbuffer);
  NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
  
  CVPixelBufferLockBaseAddress(pxbuffer, 0);
  void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
  
  
  CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
                                               frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
                                               1);
  
  CGContextTranslateCTM (context, frameSize.width, 0);
  CGContextRotateCTM (context, radians (90));
  
  
  CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                         CGImageGetHeight(image)), image);
  CGColorSpaceRelease(rgbColorSpace);
  CGContextRelease(context);
  
  CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
  
  return pxbuffer;
}

-(void)photoConfigChanged
{
//  if (self.seletType == SelectNone)
//  {
//    [self drawFrame];
//   
//  }
//  else
//  {
    [cropImageView setCropImageSource:[self saveImageFromGLView]];
//  }
  
}


- (void)drawFrame
{
	// Use shader program.
	[[ProcessGLView sharedProcessGLView] setDisplayFramebuffer];
  
  static GLfloat squareVertices[][2] = {
    -1.0f, -0.77777f,
    1.0f, -0.77777f,
    -1.0f,  1.0f,
    1.0f,  1.0f,
  };
  
  if (YES) {
    
    CGSize frameSize = videoFrameSize;
    if(self.videoFrameSize.width > self.videoFrameSize.height)
    {
      frameSize.height = 320 * frameSize.height / frameSize.width;
      frameSize.width = 320;
      
      CGFloat dy = ((1.0 + 0.77777) - (frameSize.height / 480.0 * 2)) / 2.0;
      
      squareVertices[0][1] = squareVertices[1][1] = dy - 0.77777;
      squareVertices[2][1] = squareVertices[3][1] = 1.0 - dy;
    }
    else
    {
      frameSize.width = 426 * frameSize.width / frameSize.height;
      frameSize.height = 426;
      
      CGFloat dx = (2.0 - (frameSize.width / 320.0 * 2)) / 2.0;
      
      squareVertices[0][0] = squareVertices[2][0] = dx - 1.0;
      squareVertices[1][0] = squareVertices[3][0] = 1.0 - dx;
      
      squareVertices[0][1] = squareVertices[1][1] = -0.77777;
      squareVertices[2][1] = squareVertices[3][1] = 1.0;
    }
  }
  
  
  //    [ProcessGLView sharedProcessGLView].backVideo = [takePhotoContros currentDevicePosition] == AVCaptureDevicePositionBack;
  
  [[ProcessGLView sharedProcessGLView] drawGL:&squareVertices[0][0] frameTexture:self.frameTexture];
  
  [[ProcessGLView sharedProcessGLView] presentFramebuffer];
}

@end
