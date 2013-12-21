//
//  SoundsRecordViewController.m
//  TheMusicCamera
//
//  Created by song on 13-12-14.
//  Copyright (c) 2013年 songl. All rights reserved.
//

#import "SoundsRecordViewController.h"
#import "DataManager.h"
#import "DataManager.h"

@interface SoundsRecordViewController ()

@end

@implementation SoundsRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getTodayTime
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateString = [dateFormat stringFromDate:today];
    
    NSLog(@"date: %@", dateString);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataManager = [DataManager sharedManager];

    [self getTodayTime];
    
    self.hidesBottomBarWhenPushed = YES;
    _isRecording = NO;
    _isPlaying = NO;
    
    musicNameLabel.text = dateString;
    
    [self navgationImage:@"header_recording"];
    
    UIButton *btn = [self navgationButton:@"button_back" andFrame:CGRectMake(10, 7, 46, 31)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [self navgationButton:@"button_save" andFrame:CGRectMake(260, 10, 52, 28)];
    [saveBtn addTarget:self action:@selector(saveBtuuon) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtuuon
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtuuon
{
    dataManager
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)recordVoice:(id)sender {

    

    if (_isRecording) {
//        _isRecording = NO;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"recording_play"] forState:UIControlStateNormal];

        if (!_isPlaying) {
            _isPlaying = YES;
            [recorder stop];
            recorder = nil;
            deleteBtn.hidden = NO;
            saveBtn.hidden = NO;

        }
        else
        {
            NSError *playerError;
            
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
            
            if (player == nil)
            {
                NSLog(@"ERror creating player: %@", [playerError description]);
            }
            player.delegate = self;
            
            [player play];

        }
        
    }
    else
    {
        _isRecording = YES;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"recording_stop"] forState:UIControlStateNormal];
        
        NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
        NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];
        recordedFile = [NSURL fileURLWithPath:recorderFilePath];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
        [recorder prepareToRecord];
        [recorder record];

    }


    
}

- (IBAction)deleteSounds:(id)sender
{
    _isRecording = NO;
    _isPlaying = NO;
    
    saveBtn.hidden = YES;
    deleteBtn.hidden = YES;

    [recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_rec"] forState:UIControlStateNormal];

    NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:recorderFilePath error:nil];

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

@end
