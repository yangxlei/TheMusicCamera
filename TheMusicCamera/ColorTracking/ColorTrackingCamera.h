//
//  ColorTrackingCamera.h
//  ColorTracking
//
//
//  The source code for this application is available under a BSD license.  See License.txt for details.
//
//  Created by Brad Larson on 10/9/2010.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol ColorTrackingCameraDelegate;

@interface ColorTrackingCamera : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{

	AVCaptureSession *captureSession;
	AVCaptureDeviceInput *videoInput;
	AVCaptureVideoDataOutput *videoOutput; 
    
    NSTimer *flashTimer;
    NSArray *seqArray;
    int timerSeq;
//    long long timesplit;
}

@property(nonatomic, assign) id<ColorTrackingCameraDelegate> delegate;
@property(nonatomic, retain) NSTimer* flashTimer;
@property(nonatomic, retain) NSArray* seqArray;

- (BOOL)toggleCamera; 
- (AVCaptureDevicePosition)currentDevicePosition;
- (BOOL)setCameraType:(BOOL)bFront;

- (BOOL)isFlashOn;
- (void)setFlashMode:(BOOL)on;

- (void)start;
- (void)stop;
- (void)stopWithFlashBlink;

- (BOOL)isFlashModeSupported; 
- (BOOL)isFrontCameraSupported; 
- (void)torchOnOff:(BOOL)on;

// focus related
- (BOOL)isNeedFocusAdjusting; 
- (CGPoint)getFocusPoint; 
- (void)setFocusPoint:(CGPoint)point; 
- (AVCaptureFocusMode)getCameraFocusMode; 

// session related
- (NSString *)getSessionPreset; 
- (BOOL)setSessionPreset:(NSString *)newPreset; 

+(ColorTrackingCamera*)sharedInstance;

@end

@protocol ColorTrackingCameraDelegate<NSObject>

@optional
- (void)processNewCameraFrame:(CVImageBufferRef)cameraFrame;

@end
