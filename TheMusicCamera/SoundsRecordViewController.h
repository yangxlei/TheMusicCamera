//
//  SoundsRecordViewController.h
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class DataManager;

@protocol RecordDelegate

- (void)recordDelegateEvent;

@end

@interface SoundsRecordViewController : UIViewController<AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *timeImage;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;

    NSURL *recordedFile;
    DataManager *dataManager;

    __weak IBOutlet UILabel *musicNameLabel;
    __weak IBOutlet UITextField *musicNameText;
    
    NSString *dateString;//当前时间
    __weak IBOutlet UIButton *deleteBtn;
    UIButton *saveBtn;//保存按钮
    __weak IBOutlet UIButton *recordBtn;
    float intTime;//秒数计数
    float intPlayTime;//播放秒数计数
    NSTimer   *timer ;
    __weak IBOutlet UILabel *timeLabel;
}

@property (nonatomic) BOOL isRecording;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, assign) id<RecordDelegate> delegate;

@end
