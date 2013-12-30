//
//  CameraController.h
//  TheMusicCamera
//
//  Created by yanglei on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class DataManager;

@interface CameraController : UIViewController<AVAudioPlayerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
    BOOL isPlay;
    DataManager *dataManager;
    BOOL cameraStop;
    
}

@property (nonatomic, strong) IBOutlet UIButton* backBtn;
@property (nonatomic, strong) IBOutlet UIButton* flashBtn;
@property (nonatomic, strong) IBOutlet UIButton* kirikaeBtn;
@property (nonatomic, strong) IBOutlet UIButton* sizeBtn;
@property (nonatomic, strong) IBOutlet UIButton* cameraBtn;
@property (nonatomic, strong) IBOutlet UIView* cameraView;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;

-(IBAction) back:(id)sender;
-(IBAction) flash:(id)sender;
-(IBAction) frontCamera:(id)sender;
-(IBAction) sizeClick:(id)sender;
-(IBAction) takePhoto:(id)sender;

@end
