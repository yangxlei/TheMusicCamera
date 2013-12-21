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

@interface SoundsRecordViewController : UIViewController<AVAudioPlayerDelegate>
{
    __weak IBOutlet UIImageView *timeImage;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;

    NSURL *recordedFile;
    DataManager *dataManager;

    __weak IBOutlet UILabel *musicNameLabel;
    NSString *dateString;//当前时间
    __weak IBOutlet UIButton *deleteBtn;
    UIButton *saveBtn;//保存按钮
    __weak IBOutlet UIButton *recordBtn;
}

@property (nonatomic) BOOL isRecording;
@property (nonatomic) BOOL isPlaying;

@end
