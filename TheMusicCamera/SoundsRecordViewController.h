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
    NSURL *recordedFile;
    DataManager *dataManager;

}

@end
