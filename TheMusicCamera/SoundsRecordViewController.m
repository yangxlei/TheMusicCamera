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
    canPlay = YES;
    
//    musicNameLabel.text = dateString;
    musicNameText.text = dateString;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        musicNameText.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:15];
    }

    musicNameText.delegate =self;
    
    UITapGestureRecognizer* showTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGes)];
    showTap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:showTap];

//    [self navgationImage:@"header_recording"];
    [self navgationImage:[NSString stringWithFormat:@"%@header_recording",[[NSUserDefaults standardUserDefaults] objectForKey:@"languages"]]];

    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSString *savebg;
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        savebg = @"c_btn_save";
    }else if ([currentLanguage isEqualToString:@"en"])
    {
        savebg = @"e_btn_save";
    }
    else
    {
        savebg = @"btn_save";
    }

    UIButton *btn = [self navgationButton:@"btn_back" andFrame:CGRectMake(10, 7, 52, 32)];
    [btn addTarget:self action:@selector(backBtuuon) forControlEvents:UIControlEventTouchUpInside];
    
    saveBtn = [self navgationButton:savebg andFrame:CGRectMake(250, 7, 62, 31)];
    
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

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        timeLabel.font = [UIFont fontWithName:@"A-OTF Jun Pro" size:35];
    }

    

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
    if ([dataManager getMusicId]==5) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        NSString *alertStr;
        
        if ([currentLanguage isEqualToString:@"zh-Hans"]) {
            alertStr = @"录音文件超过了保存上限\n※购买升级版，可以增加可保存上线\n删除之前的录音文件，保存刚才录音的内容吗？";
        }else if ([currentLanguage isEqualToString:@"en"])
        {
            alertStr = @"Sound file can be saved is full\n※Buy our upgrade version can save more sound\ndelete old sound file to save new?";
        }
        else
        {
            alertStr = @"録音サウンドの保存上限を超えています。\n※アプリ内課金をすると、保存上限が増えます。\n過去に録音したを削除し、今録音したものを保存してよろしいですか";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                           message:alertStr
                                                          delegate:self
                                                 cancelButtonTitle:@"NO"
                                                 otherButtonTitles:@"YES", nil];
        alertView.tag = 2;
        [alertView show];
    }
    else
    {
        Music *music = [[Music alloc]init];
        music.name = musicNameText.text;
        music.path = [NSString stringWithFormat:@"%@.caf",musicNameText.text];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appStore"] intValue]==0) {
            [dataManager deleteMusicWithID:4];
            [dataManager insertMusicInfo:music];
        }
        else
        {
            [dataManager insertMusicInfo:music];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate recordDelegateEvent];
    }

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

            if (canPlay) {
                [player play];
                
                intPlayTime = 0;
                NSTimeInterval timeInterval =0.01 ;
                //定时器
                timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                         target:self
                                                       selector:@selector(playTimer:)
                                                       userInfo:nil
                                                        repeats:YES];
                [timer fire];
            }
            canPlay = NO;
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

- (void)playTimer:(NSTimer *)theTimer
{
    intPlayTime = intPlayTime+0.01;
    NSString *timeStr = [NSString stringWithFormat:@"%.2f",intTime];
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString :@"." withString:@":"];
    
    NSString *playtimeStr = [NSString stringWithFormat:@"%.2f",intPlayTime];
    
    playtimeStr = [playtimeStr stringByReplacingOccurrencesOfString :@"." withString:@":"];

    timeLabel.text = [NSString stringWithFormat:@"%@/%@",playtimeStr,timeStr];

    if (intPlayTime==intTime) {
        [timer invalidate];
        
        _isPlaying = YES;
        recorder = nil;
        deleteBtn.hidden = NO;
        saveBtn.hidden = NO;
        canPlay = YES;
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
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog( @"currentLanguage====   %@" , currentLanguage);
    
    NSString *alertStr;
    
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        alertStr = @"不保存录音，删除吗？";
    }else if ([currentLanguage isEqualToString:@"en"])
    {
        alertStr = @"Delete without save?";
    }
    else
    {
        alertStr = @"保存をせずに削除してよろしいですか？";
    }

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                       message:alertStr
                                                      delegate:self
                                             cancelButtonTitle:@"NO"
                                             otherButtonTitles:@"YES", nil];
    alertView.tag = 1;
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1) {
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
            intPlayTime = 0.00;
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
    else
    {
        if (buttonIndex==0) {
            NSLog(@"0");
            
            
        }
        else
        {
            Music *music = [[Music alloc]init];
            music.name = musicNameText.text;
            music.path = [NSString stringWithFormat:@"%@.caf",musicNameText.text];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appStore"] intValue]==0) {
                [dataManager deleteMusicWithID:4];
                [dataManager insertMusicInfo:music];
            }
            else
            {
                [dataManager insertMusicInfo:music];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [self.delegate recordDelegateEvent];
        }

    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
