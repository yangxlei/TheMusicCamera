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
#import "Music.h"
#import "Public.h"

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
    
    dateString = [NSString stringWithFormat:@"%@-%d",dateString,[dataManager selectMusicDate]];
    
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
//    NSLog(@"date: %@", dateString);

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
    
//    musicNameLabel.text = dateString;
    musicNameText.text = dateString;
    musicNameText.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:15];

    UITapGestureRecognizer* showTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGes)];
    showTap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:showTap];

    [self navgationImage:@"header_recording"];
    
    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [self navgationButton:@"button_save" andFrame:CGRectMake(260, 10, 52, 28)];
    [saveBtn addTarget:self action:@selector(saveBtuuon) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.hidden = YES;
    
//////////////////////////////////////////////////////////////////////////////////
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];
    recordedFile = [NSURL fileURLWithPath:recorderFilePath];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:nil error:nil];
    [recorder prepareToRecord];

    timeLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:35];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGes
{
    [musicNameText resignFirstResponder];
}

- (void)backBtuuon
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtuuon
{
    Music *music = [[Music alloc]init];
    music.name = musicNameText.text;
    music.path = [NSString stringWithFormat:@"%@.caf",musicNameText.text];
    [dataManager insertMusicInfo:music];

    [self.navigationController popViewControllerAnimated:YES];
    
    [self.delegate recordDelegateEvent];
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
            [timer invalidate];
            musicNameText.enabled = YES;

        }
        else
        {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            NSError *sessionError;
            [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
            
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&sessionError];
            
            if (player == nil)
            {
                NSLog(@"ERror creating player: %@", [sessionError description]);
            }
            player.delegate = self;
            player.volume=1.0;//0.0~1.0之间

            [player play];

        }
        
    }
    else
    {
        _isRecording = YES;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"recording_stop"] forState:UIControlStateNormal];
        
        [recorder record];

        intTime = 0;
        
        musicNameText.enabled = NO;
        
        if (iPhone5) {
            
        }
        else
        {
            timeImage.frame = CGRectMake(timeImage.frame.origin.x, timeImage.frame.origin.y-50, timeImage.frame.size.width, 481);
        }

        NSTimeInterval timeInterval =0.01 ;
        //定时器
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                               target:self
                                                             selector:@selector(showTimer:)
                                                             userInfo:nil
                                                              repeats:YES];
        [timer fire];
        
    }
}

- (void)showTimer:(NSTimer *)theTimer
{
//    intTime++;
    intTime = intTime+0.01;
    
    NSString *timeStr = [NSString stringWithFormat:@"%.2f",intTime];
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString :@"." withString:@":"];
    
    timeLabel.text = [NSString stringWithFormat:@"%@/10:00",timeStr];

    if ((int)intTime==10) {
        [timer invalidate];
        
        _isPlaying = YES;
        [recorder stop];
        recorder = nil;
        deleteBtn.hidden = NO;
        saveBtn.hidden = NO;
        [recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_play"] forState:UIControlStateNormal];
        musicNameText.enabled = YES;

    }
    if (iPhone5) {
        timeImage.frame = CGRectMake(timeImage.frame.origin.x, timeImage.frame.origin.y-0.21f, timeImage.frame.size.width, 481);
    }
    else
    {
        timeImage.frame = CGRectMake(timeImage.frame.origin.x, timeImage.frame.origin.y-0.19f, timeImage.frame.size.width, 481);
    }

    
    NSLog(@"%f   %f   %f   %f   ",timeImage.frame.origin.x,timeImage.frame.origin.y,timeImage.frame.size.width,timeImage.frame.size.height);
    

}

- (IBAction)deleteSounds:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"保存をせずに削除してよろしいですか？"
                                                      delegate:self
                                             cancelButtonTitle:@"NO"
                                             otherButtonTitles:@"YES", nil];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"0");
        
        
    }
    else
    {
        _isRecording = NO;
        _isPlaying = NO;
        
        saveBtn.hidden = YES;
        deleteBtn.hidden = YES;
        intTime = 0.00;
        timeLabel.text = [NSString stringWithFormat:@"0:00/10:00"];
        
        [recordBtn setBackgroundImage:[UIImage imageNamed:@"recording_rec"] forState:UIControlStateNormal];
        timeImage.frame = CGRectMake(timeImage.frame.origin.x, 346, timeImage.frame.size.width, 481);
        
        NSString *savePath = [dataManager.downloadPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"music"]];
        NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", savePath,dateString];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:recorderFilePath error:nil];
        
        [dataManager deleteMusicWithName:[NSString stringWithFormat:@"%@.caf",dateString]];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    
}

@end
