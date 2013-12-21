//
//  ColorTrackingCamera.m
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/9/2010.
//

#import "ColorTrackingCamera.h"
#import "AppDelegate.h"
//#import "CTime.h"

@implementation ColorTrackingCamera
@synthesize flashTimer;
@synthesize seqArray;

+(ColorTrackingCamera*)sharedInstance
{
    static ColorTrackingCamera* instance = nil;
    if (instance == nil)
    {
        instance = [[ColorTrackingCamera alloc] init];
    }
    return instance;
}


#define USED_VIDEO_PREST AVCaptureSessionPresetPhoto

- (id)init; 
{
	if (!(self = [super init]))
		return nil;
	
	// Grab the back-facing camera
	AVCaptureDevice *backFacingCamera = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) 
	{
		if ([device position] == AVCaptureDevicePositionBack) 
		{
			backFacingCamera = device;
		}
	}
	
	// Create the capture session
	captureSession = [[AVCaptureSession alloc] init];
    
    // Start capturing
    if ([captureSession canSetSessionPreset:USED_VIDEO_PREST]) {
        [captureSession setSessionPreset:USED_VIDEO_PREST];
    }
	
	// Add the video input	
	NSError *error = nil;
	videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:backFacingCamera error:&error];
	if ([captureSession canAddInput:videoInput]) 
	{
		[captureSession addInput:videoInput];
	}
    
	// Add the video frame output	
	videoOutput = [[AVCaptureVideoDataOutput alloc] init];
	[videoOutput setAlwaysDiscardsLateVideoFrames:YES];
	// Use RGB frames instead of YUV to ease color processing
	[videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];

	[videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

	if ([captureSession canAddOutput:videoOutput])
	{
		[captureSession addOutput:videoOutput];
	}
	else
	{
		NSLog(@"Couldn't add video output");
	}
	
//    timesplit = mq_get_mstime();
  
	return self;
}

//- (void)dealloc 
//{
//	[captureSession stopRunning];
//
//	[captureSession release];
//	[videoOutput release];
//	[videoInput release]; 
//    
//	[super dealloc];
//}

- (void)start
{
    
    if (![captureSession isRunning])
	{
		[captureSession startRunning];
	};
}

- (void)torchOnOff:(BOOL)on
{
    AVCaptureDevice *currentDevice = [videoInput device]; 
    
    if (on == (currentDevice.torchMode == AVCaptureTorchModeOn))
    {
        return;
    }
    if ([currentDevice hasFlash]) {
        NSError *error = [[NSError alloc] init] ;
        
        if (on) {
            if ([currentDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
                
                if ([currentDevice lockForConfiguration:&error]) {
                    currentDevice.torchMode = AVCaptureTorchModeOn;
                }
                
                [currentDevice unlockForConfiguration]; 
            }
        } else {
            if ([currentDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
                [currentDevice lockForConfiguration:&error]; 
                
                if ([currentDevice lockForConfiguration:&error]) {
                    currentDevice.torchMode = AVCaptureTorchModeOff;
                }
                
                [currentDevice unlockForConfiguration]; 
            }
        }
    }
}

-(void) tick
{
    if (timerSeq == (int)[self.seqArray count])
    {
        [self.flashTimer invalidate];
        self.flashTimer = nil;
        self.seqArray = nil;
        [self stop];
        return;
    }

    int seqValue = [[self.seqArray objectAtIndex:timerSeq] intValue];
    [self torchOnOff:seqValue];
    timerSeq++;
}

-(void)blinkFlash:(NSString*) flashSeq;
{
    self.seqArray = [flashSeq componentsSeparatedByString:@","];
    timerSeq = 0;
    self.flashTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 
                                     target:self 
                                   selector:@selector(tick) 
                                   userInfo:nil 
                                    repeats:YES];
}

- (void) stopWithFlashBlink
{
    if ([self isFlashOn])
    {
        [self blinkFlash:@"1,1,1,1,1,1,0,1,0,1,1,0"];
    }
    else
    {
        [self stop];
    }
}

- (void)stop
{    
    if ([captureSession isRunning])
	{
		[captureSession stopRunning];
	};
    
    
    // reset focus mode
    AVCaptureDevice *currentDevice = [videoInput device]; 
    
    NSError *error = [[NSError alloc] init];
    
    if ([currentDevice lockForConfiguration:&error]) {
        
        if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            
            currentDevice.focusPointOfInterest = CGPointMake(0.5, 0.5); 
            currentDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        }
        
        if ([currentDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            
            currentDevice.exposurePointOfInterest = CGPointMake(0.5, 0.5); 
            currentDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
         
    }
    
    [currentDevice unlockForConfiguration]; 
}

#pragma mark -
#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
//    long long timenow = mq_get_mstime();
  
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    if(timenow - timesplit > 100)
    {
        [self.delegate processNewCameraFrame:pixelBuffer];
//        timesplit = timenow;
    }
}

#pragma mark - Device Related

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (NSUInteger) micCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] count];
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

#pragma mark -
#pragma mark Accessors

@synthesize delegate;



- (BOOL)setCameraType:(BOOL)bFront
{
    BOOL success = NO;
    
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        
        if (bFront)
        {
            if (position == AVCaptureDevicePositionFront)
            {
                return YES;
            }
        }
        else
        {
            if (position == AVCaptureDevicePositionBack)
            {
                return YES;
            }
        }
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [captureSession beginConfiguration];
            [captureSession removeInput:videoInput];
            if ([captureSession canAddInput:newVideoInput]) {
                [captureSession addInput:newVideoInput];
//                [videoInput release];
//                videoInput = [newVideoInput retain];
              videoInput = newVideoInput;
            } else {
                [captureSession addInput:videoInput];
            }
            [captureSession commitConfiguration];
            success = YES;
        } else if (error) {
        }
//        [newVideoInput release];
    }
    
bail:
    return success;

}

- (BOOL)toggleCamera
{
    BOOL success = NO;
    
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [captureSession beginConfiguration];
            [captureSession removeInput:videoInput];
            if ([captureSession canAddInput:newVideoInput]) {
                [captureSession addInput:newVideoInput];
//                [videoInput release];
//                videoInput = [newVideoInput retain];
              videoInput = newVideoInput;
              
            } else {
                [captureSession addInput:videoInput];
            }
            [captureSession commitConfiguration];
            success = YES;
        } else if (error) {
        }
//        [newVideoInput release];
    }
    
bail:
    return success;
}

- (AVCaptureDevicePosition)currentDevicePosition
{
    return [[videoInput device] position];
}

- (BOOL)isFlashOn
{
    AVCaptureDevice *currentDevice = [videoInput device]; 
    return currentDevice.flashMode == AVCaptureFlashModeOn;
}

- (void)setFlashMode:(BOOL)on
{
    AVCaptureDevice *currentDevice = [videoInput device]; 
    
    if ([currentDevice hasFlash]) {
        NSError *error = [[NSError alloc] init] ; 
        
        if (on) {
            if ([currentDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
                
                if ([currentDevice lockForConfiguration:&error]) {
                    currentDevice.flashMode = AVCaptureFlashModeOn;
                }
                
                [currentDevice unlockForConfiguration]; 
            }
        } else {
            if ([currentDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
                [currentDevice lockForConfiguration:&error]; 
                
                if ([currentDevice lockForConfiguration:&error]) {
                    currentDevice.flashMode = AVCaptureFlashModeOff;
                }
                
                [currentDevice unlockForConfiguration]; 
            }
        }
    }
}

- (BOOL)isFlashModeSupported
{
    return [[videoInput device] hasFlash]; 
}

- (BOOL)isFrontCameraSupported
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1; 
}

#pragma mark - Focus Related
- (BOOL)isNeedFocusAdjusting
{
    if (![captureSession isRunning]) return NO; 
    
    if (![[videoInput device] isFocusModeSupported:AVCaptureFocusModeAutoFocus]) return NO; 
    
    if ([[videoInput device] isFocusPointOfInterestSupported]) {
        
        return [[videoInput device ] isAdjustingFocus]; 
    }
    
    return NO; 
}

- (CGPoint)getFocusPoint
{
    return [videoInput device].focusPointOfInterest; 
}

- (void)setFocusPoint:(CGPoint)point
{
    AVCaptureDevice *currentDevice = [videoInput device]; 
    
    NSError *error = [[NSError alloc] init] ;
    
    if ([currentDevice lockForConfiguration:&error]) {
        
        if ([currentDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            
            currentDevice.focusMode = AVCaptureFocusModeAutoFocus;
            [currentDevice setFocusPointOfInterest:point]; 
        }        
        
        if ([currentDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            currentDevice.exposureMode = AVCaptureExposureModeAutoExpose;
            [currentDevice setExposurePointOfInterest:point]; 
            
        }
         
    }
    
    [currentDevice unlockForConfiguration]; 
}

- (AVCaptureFocusMode)getCameraFocusMode
{
    AVCaptureDevice *currentDevice = [videoInput device];
    
    return [currentDevice focusMode]; 
}

#pragma mark - Session related
- (NSString *)getSessionPreset
{
    return [captureSession sessionPreset]; 
}

- (BOOL)setSessionPreset:(NSString *)newPreset
{
    if ([captureSession canSetSessionPreset:newPreset]) {
        [captureSession setSessionPreset:newPreset]; 
        
        return YES; 
    }
    
    return NO; 
}
@end
